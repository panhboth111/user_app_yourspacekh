import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/parking_provider.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_ui.dart';
import 'package:user_app_yourspacekh/screens/home_screen/map_ui.dart';

import 'package:user_app_yourspacekh/services/space_service.dart';
import 'package:user_app_yourspacekh/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpaceService spaceService = SpaceService();
  UserService _userService = UserService();
  late FirebaseMessaging messaging;
  void onMarkerTap(SpaceModel spaceModel) {}

  _getReceiptText(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xff979797), fontSize: 14),
        ),
        Text(value)
      ],
    );
  }

  parkingCompletedDialog(BuildContext context) {
    SpaceProvider spaceProvider =
        Provider.of<SpaceProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 16,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Parking Receipt",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(spaceProvider.activeSpace!.price,
                            style: TextStyle(
                                fontSize: 36,
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text("SUCCESSFULLY PAID",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 35, bottom: 35),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _getReceiptText(
                                      "Transaction Number", "#11012013010"),
                                  _getReceiptText("Parking Lot",
                                      spaceProvider.activeSpace!.name),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _getReceiptText(
                                      "Transaction Number", "#11012013010"),
                                  _getReceiptText(
                                      "Parking Lot", "Mitpheap Parking"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Transaction Problem?"),
                              Text("Contact Us"),
                            ],
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            primary: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Provider.of<ParkingProvider>(context, listen: false)
                                .setBottomCardType(0);
                            Navigator.pop(context);
                          },
                          child: Text("Leave Feedback")),
                      width: double.infinity),
                  Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ParkingProvider>(context, listen: false)
                              .setBottomCardType(0);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Okay",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          primary: Colors.white,
                        ),
                      ),
                      width: double.infinity),
                ],
              ),
            ),
          );
        });
  }

  _getDeviceId() async {
    String identifier = "";
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor;
      }
      return identifier;
    } catch (e) {
      return "";
    }
  }

  showNotification(BuildContext context, String title, String body) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(body, style: TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Okay")),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {}

  @override
  void initState() {
    super.initState();

    Provider.of<SpaceProvider>(context, listen: false).initialize();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) async {
      _userService.addToken(value!, await _getDeviceId());
    });
    FirebaseMessaging.onMessage.listen((msg) {
      if (msg.data['event'] == 'accepted') {
        showNotification(
            context, msg.notification!.title!, msg.notification!.body!);
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(3);
      } else if (msg.data['event'] == 'parking') {
        showNotification(context, "Request Accepted", "You are now parking");
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(4);
      } else if (msg.data['event'] == 'done') {
        parkingCompletedDialog(context);
      }
    });
    FirebaseMessaging.onBackgroundMessage(
        (message) => _firebaseMessagingBackgroundHandler(message));
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      showNotification(
          context, msg.notification!.title!, msg.notification!.body!);
      if (msg.data['event'] == 'accepted') {
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(3);
      } else if (msg.data['event'] == 'parking') {
        showNotification(context, "Request Accepted", "You are now parking");
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(5);
      } else if (msg.data['event'] == 'done') {

        parkingCompletedDialog(context);
      }
    });
    // parkingCompletedDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            MapUI(
              onMarkerTap: onMarkerTap,
            ),
            HomeUI()
          ],
        ),
      ),
    );
  }
}
