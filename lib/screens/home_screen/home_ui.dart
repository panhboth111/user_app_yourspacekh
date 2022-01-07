// ignore_for_file: unnecessary_new, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/parking_provider.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';
import 'package:user_app_yourspacekh/screens/booking_screen/confirm_booking_screen.dart';
import 'package:user_app_yourspacekh/screens/login_screen/login_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/profile_screen.dart';
import 'package:user_app_yourspacekh/screens/register_screen/register_screen.dart';
import 'package:user_app_yourspacekh/services/parking_service.dart';

class HomeUI extends StatelessWidget {
  final currentLocation;
  ParkingService _parkingService = ParkingService();
  late SpaceModel? activeSpace;

  HomeUI({Key? key, this.currentLocation, this.activeSpace}) : super(key: key);

  void onBookSpotPressed(BuildContext context, SpaceModel space) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmBookingScreen(
                  activeSpace: space,
                )));
  }
  timeFormat(String time){
    var timeSplit = time.split(":");
    var originalHour = int.parse(timeSplit[0]);
    var hour = "";
    TimeOfDay timeOfDay =  TimeOfDay(hour: int.parse(timeSplit[0]), minute: int.parse(timeSplit[1]));
    if(originalHour <= 12) {
      hour = originalHour.toString();
    }
    else {
      var remainder = originalHour % 12;
      hour = remainder.toString();
    }
    return hour +":"+timeSplit[1] + " "+timeOfDay.period.toString().split(".")[1].toUpperCase();
    // TimeOfDay timeOfDay =  TimeOfDay(hour: int.parse(time.split(":")[0]), minute: int.parse(time.split(":")[1]));
    // return timeOfDay.period;
  }
  onContactUsPressed() {}
  _getReceiptText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xff979797), fontSize: 14),
        ),
        Text(value)
      ],
    );
  }

  onCancelBookingPressed(BuildContext context) async {
    var appLocal = AppLocalizations.of(context);

    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(appLocal!.cancel_booking + "?",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text(appLocal.cancel_desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            side: const BorderSide(
                                width: 2, color: Color(0xff575F6E)),
                            padding:
                                const EdgeInsets.only(left: 30, right: 30)),
                        onPressed: () {
                          
                        },
                        child: const Text("Stay",
                            style: TextStyle(color: Color(0xff575F6E))),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var response = await _parkingService.cancelParking(
                              Provider.of<ParkingProvider>(context,
                                      listen: false)
                                  .currentParking!
                                  .id!);

                          if (response) {
                            Provider.of<ParkingProvider>(context,listen: false).setBottomCardType(0);
                            Provider.of<SpaceProvider>(context,listen: false).setActiveSpace(null);
                            Navigator.pop(context);

                          }
                        },
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding:
                                const EdgeInsets.only(left: 30, right: 30)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void onQRCodePressed() {}

  Widget _getBottomCardContainer(
      BuildContext context, int bottomCardType, SpaceModel? activeSpace) {
    var appLocal = AppLocalizations.of(context);

    switch (bottomCardType) {
      case 1:
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 11,
            child: Container(
              padding: const EdgeInsets.all(15),
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
                            activeSpace!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            activeSpace.address,
                            style: const TextStyle(
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
                          const Text(
                            "Parking",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffa5aab7)),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cases_sharp,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                               Text("Open: "+timeFormat(activeSpace.openTime)+"-"+timeFormat(activeSpace.closeTime)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.car_repair,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text("Price: \$" + activeSpace.price +"/night"),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              primary: Theme.of(context).primaryColor),
                          child: const Text("Book Spot"),
                          onPressed: () =>
                              onBookSpotPressed(context, activeSpace))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      case 2:
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 11,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocal!.space_connecting,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(appLocal.please_wait,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 30, right: 30)),
                    onPressed: () {},
                    child: Text(
                      appLocal.contact_us,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.only(left: 30, right: 30)),
                    onPressed: () {
                      // _parkingService.cancelParking();
                      onCancelBookingPressed(context);
                    },
                    child: Text(
                      appLocal.cancel_booking,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case 3:
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 11,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocal!.currently_reserving,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(activeSpace!.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.only(left: 30, right: 30)),
                    onPressed: () {
                      // _parkingService.cancelParking();
                      onCancelBookingPressed(context);
                    },
                    child: Text(
                      appLocal.cancel_booking,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case 4:
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 11,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocal!.currently_parking,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(activeSpace!.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.only(left: 30, right: 30)),
                    onPressed: () {},
                    child: Text(
                      appLocal.contact_us,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParkingProvider, SpaceProvider>(
        builder: (consumerContext, bottomCardModel, spaceModel, child) {
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
                      int status =
                          Provider.of<AuthProvider>(context, listen: false)
                              .authStatus;
                      if (status == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      } else if (status == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      }
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
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    bottomCardModel.bottomCardType != 0 &&
                            spaceModel.activeSpace != null
                        ? _getBottomCardContainer(
                            context,
                            bottomCardModel.bottomCardType,
                            spaceModel.activeSpace!)
                        : Container()
                  ],
                ),
              )
            ],
          ));
    });
  }
}
