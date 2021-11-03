import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';

import 'package:user_app_yourspacekh/providers/bottom_card_provider.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_ui.dart';
import 'package:user_app_yourspacekh/screens/home_screen/map_ui.dart';

import 'package:user_app_yourspacekh/services/space_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpaceService spaceService = new SpaceService();
  Completer<GoogleMapController> _mapController = Completer();
  // to store markers for parking spaces
  Map<String, Marker> _markers = {};
  // the space that has been clicked on
  SpaceModel? activeSpace = null;

  // redirects the camera to the user's current location on click
  void currentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    var location =
        Provider.of<LocationProvider>(context, listen: false).locationPosition;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(location!.latitude, location.longitude),
        zoom: 18,
      ),
    ));
  }

  //displays bottom card for booking when marker is clicked
  void onMarkerTapped(SpaceModel space) {
    var bottomCardProvider =
        Provider.of<BottomCardProvider>(context, listen: false);

    setState(() {
      activeSpace = space;
    });
    bottomCardProvider.setBottomCardType(1);
  }

  //hide the bottom card on map clicked if bottom card type is 1
  void onMapTapped() {
    var bottomCardProvider =
        Provider.of<BottomCardProvider>(context, listen: false);
    if (bottomCardProvider.bottomCardType == 1) {
      bottomCardProvider.setBottomCardType(0);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            MapUI(
              mapController: _mapController,
              onMarkerTapped: onMarkerTapped,
              onGoogleMapTapped: onMapTapped,
            ),
            HomeUI(
              currentLocation: currentLocation,
              activeSpace: activeSpace,
            )
          ],
        ),
      ),
    );
  }
}
