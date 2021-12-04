import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_ui.dart';
import 'package:user_app_yourspacekh/screens/home_screen/map_ui.dart';

import 'package:user_app_yourspacekh/services/space_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpaceService spaceService = SpaceService();
  late FirebaseMessaging messaging;
  void onMarkerTap(SpaceModel spaceModel) {}

  @override
  void initState() {
    super.initState();

    Provider.of<SpaceProvider>(context, listen: false).initialize();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      print("token");
        print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MapUI(
            onMarkerTap: onMarkerTap,
          ),
          HomeUI()
        ],
      ),
    );
  }
}
