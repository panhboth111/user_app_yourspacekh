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
import 'package:user_app_yourspacekh/providers/parking_provider.dart';
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
  late StreamSubscription<CompassEvent>? _compassStream;
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
          if (Provider.of<ParkingProvider>(context, listen: false)
                  .bottomCardType <=
              1) {
            Provider.of<ParkingProvider>(context, listen: false)
                .setBottomCardType(1);
            Provider.of<SpaceProvider>(context, listen: false)
                .setActiveSpace(space);
          }
          setState(() {
            _selectedSpaceId = space.id;
          });
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: space.coordinate, zoom: 20)));
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
        await _getBytesFromAsset('assets/images/normalMarker.png', 90));
    _selectedMarkerIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/selectedMarker.png', 110));
    _currentLocationIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/current_location.png', 110));
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

    _compassStream = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _currentHeading = event.heading;
        });
      }
    });

    _geolocatorStream = Geolocator.getPositionStream(
            intervalDuration: const Duration(milliseconds: 50))
        .listen((event) {
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(event.latitude, event.longitude);
        });
      }
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
    _compassStream?.cancel();
    _compassStream = null;
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
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(
                children: [
                  GoogleMap(
                      markers: <Marker>{
                        _buildLocationMarker(),
                        ..._getMarkers(spaceProvider.spaces)
                      },
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          zoom: 20,
                          target: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                              primary: Colors.blue, // <-- Button color
                              onPrimary: Colors.red, // <-- Splash color
                            ),
                            onPressed: () async {
                              var position =
                                  await Geolocator.getCurrentPosition();
                              _mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      zoom: 19,
                                      target: LatLng(position.latitude,
                                          position.longitude))));
                            },
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                            ),
                          )))
                ],
              );
            });
      });
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
