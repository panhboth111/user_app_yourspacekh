import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';

class MapUI extends StatefulWidget {
  final void Function(SpaceModel) onMarkerTap;

  const MapUI({Key? key, required this.onMarkerTap}) : super(key: key);

  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  BitmapDescriptor? _markerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  BitmapDescriptor? _currentLocationIcon;

  LatLng? _currentLocation;
  double? _currentHeading;

  final Completer<GoogleMapController> _controller = Completer();
  late StreamSubscription<Position>? _geolocatorStream;
  late GoogleMapController _mapController;

  int _selectedSpaceId = -1;

  Set<Marker> _getMarkers(Set<SpaceModel> spaces) {
    Set<Marker> markers = {};
    for (final space in spaces) {
      markers.add(Marker(
        draggable: false,
        consumeTapEvents: true,
        markerId: MarkerId(space.coordinate.latitude.toString() +
            space.coordinate.longitude.toString()),
        position: space.coordinate,
        icon:
            _selectedSpaceId == space.id ? _selectedMarkerIcon! : _markerIcon!,
        onTap: () {
          setState(() {
            _selectedSpaceId = space.id;
          });
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: space.coordinate, zoom: 14)));
          widget.onMarkerTap(space);
        },
      ));
    }

    return markers;
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _loadMarker() async {
    _markerIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/normalMarker.png', 60));
    _selectedMarkerIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/selectedMarker.png', 90));
    _currentLocationIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/current_location.png', 90));
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position> _getUserLocation() async {
    return Geolocator.getCurrentPosition();
  }

  Future<void> _listenCurrentLocation() async {
    await _checkLocationPermission();

    FlutterCompass.events?.listen((event) {
      setState(() {
        _currentHeading = event.heading;
      });
    });

    Geolocator.getPositionStream(
            intervalDuration: const Duration(milliseconds: 50))
        .listen((event) {
      setState(() {
        _currentLocation = LatLng(event.latitude, event.longitude);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _loadMarker();
    _listenCurrentLocation();

    Provider.of<SpaceProvider>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
    _geolocatorStream?.cancel();
    _geolocatorStream = null;
  }

  Marker _buildLocationMarker() {
    return Marker(
        markerId: const MarkerId("myLocation"),
        anchor: const ui.Offset(0.5, 0.560546875),
        icon: _currentLocationIcon!,
        position: _currentLocation!,
        rotation: _currentHeading!);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation != null &&
        _currentHeading != null &&
        _currentLocationIcon != null &&
        _markerIcon != null &&
        _selectedMarkerIcon != null) {
      return Consumer<SpaceProvider>(builder: (ctx, spaceProvider, child) {
        return FutureBuilder(
            future: _getUserLocation(),
            builder: (ctx, AsyncSnapshot<Position> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return GoogleMap(
                  markers: <Marker>{
                    _buildLocationMarker(),
                    ..._getMarkers(spaceProvider.spaces)
                  },
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  myLocationEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude)));
            });
      });
    } else {
      return const CircularProgressIndicator();
    }
  }
}
