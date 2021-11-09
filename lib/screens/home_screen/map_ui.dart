import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';

class MapUI extends StatefulWidget {
  final void Function(SpaceModel) onMarkerTap;

  const MapUI({Key? key, required this.onMarkerTap}) : super(key: key);

  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;
  BitmapDescriptor? _markerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  int _selectedSpaceId = -1;

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Set<Marker>> _getMarkers(Set<SpaceModel> spaces) async {
    Set<Marker> markers = {};
    _markerIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/normalMarker.png', 70));
    _selectedMarkerIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset('assets/images/selectedMarker.png', 70));

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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SpaceProvider>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, SpaceProvider>(
        builder: (ctx, locationProvider, spaceProvider, child) {
      return FutureBuilder(
          future: _getMarkers(spaceProvider.spaces),
          builder: (ctx, AsyncSnapshot<Set<Marker>> snapshot) {
            if (snapshot.hasData && locationProvider.locationPosition != null) {
              return GoogleMap(
                  zoomGesturesEnabled: true,
                  markers: snapshot.data!,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      zoom: 18, target: locationProvider.locationPosition!));
            }
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          });
    });
  }
}
