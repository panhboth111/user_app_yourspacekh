import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/services/space_service.dart';

class MapUI extends StatefulWidget {
  Completer<GoogleMapController>? mapController;
  final onMarkerTapped;
  final onGoogleMapTapped;
  MapUI(
      {Key? key,
      this.mapController,
      this.onMarkerTapped,
      this.onGoogleMapTapped})
      : super(key: key);
  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  SpaceService _spaceService = new SpaceService();
  Map<String, Marker> _markers = {};

//initialize markers and controller on map created
  Future<void> _onMapCreated(GoogleMapController controller) async {
    widget.mapController!.complete(controller);
    final spaces = await _spaceService.getSpaces();
    if (spaces != null) {
      setState(() {
        _markers.clear();
        for (final space in spaces) {
          final marker = Marker(
              markerId: MarkerId(space.id),
              position: space.coordinate,
              infoWindow: InfoWindow(title: space.name, snippet: space.address),
              onTap: () {
                widget.onMarkerTapped(space);
              });
          _markers[space.id] = marker;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return GoogleMap(
            onTap: (value) {
              widget.onGoogleMapTapped();
            },
            zoomGesturesEnabled: true,
            markers: _markers.values.toSet(),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(zoom: 18, target: model.locationPosition!));
      } else {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ),
        );
      }
    });
  }
}
