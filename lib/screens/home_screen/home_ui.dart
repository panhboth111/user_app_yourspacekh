// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/bottom_card_provider.dart';
import 'package:user_app_yourspacekh/screens/booking_screen/confirm_booking_screen.dart';
import 'package:user_app_yourspacekh/screens/login_screen/login_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/profile_screen.dart';

class HomeUI extends StatelessWidget {
  var currentLocation;

  SpaceModel? activeSpace;

  HomeUI({Key? key, this.currentLocation, this.activeSpace});

  void onBookSpotPressed(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConfirmBookingScreen()));
  }

  void onContactUsPressed() {}
  void onCancelBookingPressed() {}
  void onQRCodePressed() {}
  Widget _getBottomCardContainer(
      BuildContext context, int bottomCardType, SpaceModel activeSpace) {
    switch (bottomCardType) {
      case 1:
        return Container(
          width: double.infinity,
          child: Card(
            elevation: 11,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeSpace.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "№ 101, St. 254",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff7f7f7f)),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "24H",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            "Parking",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffa5aab7)),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cases_sharp,
                                color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Price: " + activeSpace.price),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                primary: Theme.of(context).primaryColor),
                            child: Text("Book Spot"),
                            onPressed: () => onBookSpotPressed(context)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget build(BuildContext context) {
    return Consumer<BottomCardProvider>(
        builder: (consumerContext, model, child) {
      return Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Provider.of<AuthProvider>(context).isAuthed
                                      ? const ProfileScreen()
                                      : const LoginScreen()));
                    },
                    child: const Icon(Icons.person, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                        elevation: 11.0,
                        padding: const EdgeInsets.only(top: 11, bottom: 11),
                        primary: Colors.white),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: currentLocation,
                      child: Icon(Icons.location_on,
                          color: Theme.of(context).primaryColor),
                      style: ElevatedButton.styleFrom(
                          elevation: 11,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          primary: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    model.bottomCardType != 0 && activeSpace != null
                        ? _getBottomCardContainer(
                            context, model.bottomCardType, activeSpace!)
                        : Container()
                  ],
                ),
              )
            ],
          ));
    });
  }
}
