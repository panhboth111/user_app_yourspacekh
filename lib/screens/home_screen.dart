import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/screens/login_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen.dart';
import 'package:user_app_yourspacekh/services/space_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpaceService spaceService = new SpaceService();
  Completer<GoogleMapController> _mapController = Completer();
  Map<String, Marker> _markers = {};
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _activeMarkerIcon;
  SpaceModel? _activeSpace = null;
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

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    final spaces = await spaceService.getSpaces();
    if (spaces != null) {
      setState(() {
        _markers.clear();
        for (final space in spaces) {
          final marker = Marker(
              markerId: MarkerId(space.id),
              position: space.coordinate,
              infoWindow: InfoWindow(title: space.name, snippet: space.address),
              onTap: () {
                setState(() {
                  _activeSpace = space;
                });
              });
          _markers[space.id] = marker;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).initialize();
    _getBytesFromAsset('assets/images/marker.png', 100).then((value) => {
          setState(() {
            _markerIcon = BitmapDescriptor.fromBytes(value);
          })
        });
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
                    onTap: (value) {
                      setState(() {
                        _activeSpace = null;
                      });
                    },
                    zoomGesturesEnabled: true,
                    markers: _markers.values.toSet(),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Material(
                            elevation: 11.0,
                            child: TextField(
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                hintText: AppLocalizations.of(context)!.search,
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
                                    builder: (context) =>
                                        Provider.of<AuthProvider>(context)
                                                .isAuthed
                                            ? ProfileScreen()
                                            : LoginScreen()));
                          },
                          child: Icon(Icons.person, color: Colors.black),
                          style: ElevatedButton.styleFrom(
                              elevation: 11.0,
                              padding: EdgeInsets.only(top: 11, bottom: 11),
                              primary: Colors.white),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _currentLocation,
                            child: Icon(Icons.location_on,
                                color: Theme.of(context).primaryColor),
                            style: ElevatedButton.styleFrom(
                                elevation: 11,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(15),
                                primary: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _activeSpace != null
                              ? Container(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 11,
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _activeSpace!.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    "№ 101, St. 254",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff7f7f7f)),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "24H",
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Text(
                                                    "Parking",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xffa5aab7)),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.cases_sharp,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Open:24/7"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.car_rental,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text("Price: " +
                                                          _activeSpace!.price),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding: EdgeInsets
                                                                .only(
                                                                    left: 30,
                                                                    right: 30),
                                                            primary: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                    child: Text("Book Spot"),
                                                    onPressed: () {}),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: _currentLocation,
      //   child: Icon(
      //     Icons.location_on,
      //     color: Theme.of(context).primaryColor,
      //   ),
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(30.0))),
      // ),
    );
  }
}
