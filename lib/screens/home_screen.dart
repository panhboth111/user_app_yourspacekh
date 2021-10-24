import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialize();
  }

  Completer<GoogleMapController> _mapController = Completer();
  void _currentLocation() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Consumer<LocationProvider>(
                builder: (consumerContext, model, child) {
              if (model.locationPosition != null) {
                return GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 18, target: model.locationPosition!));
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                );
              }
            }),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 30),
              child: Row(
                children: [
                  Flexible(
                    child: Material(
                      elevation: 11.0,
                      child: TextField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Where to park?',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Icon(Icons.person, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                        elevation: 11.0,
                        padding: EdgeInsets.only(top: 11, bottom: 11),
                        primary: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _currentLocation,
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
      ),
    );
  }
}
