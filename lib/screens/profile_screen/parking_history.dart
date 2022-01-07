import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:user_app_yourspacekh/models/parking_model.dart';
import 'package:user_app_yourspacekh/services/parking_service.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  ParkingService _parkingService = ParkingService();
  Set<ParkingModel?> _parkings = {};
  Color? _statusToColor(String status) {
    switch (status) {
      case "BOOKING":
        return Colors.amber[800];
      case "ACCEPTED":
        return Colors.cyan[500];
      case "PARKING":
        return Colors.blue[500];
      case "DONE":
        return Colors.green[500];
      case "CANCELLED":
        return Colors.red[900];
      default:
        return Colors.white;
    }
  }

  Container _parkingInfo(ParkingModel parking) {
    return Container(
      height: 85,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.plateNumberCity!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    parking.plateNumber!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('dd/MM/yyyy hh:mm')
                    .format(DateTime.parse(parking.preferredDate!)),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$" + parking.price!,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
              Text(
                parking.spaceName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                parking.status!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: _statusToColor(parking.status!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getHistoryCard(BuildContext context, ParkingModel parking) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black12, width: 1.0),
          borderRadius: BorderRadius.circular(10.0)),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [_parkingInfo(parking)],
              )),
        ],
      ),
    );
  }

  Widget _getNoHistoryUI(appLocal) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 120,
            color: Color(0xffc7c7c7),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              appLocal.no_history,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 70, right: 70),
            child: Text(
              appLocal.no_history_desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 80),
            height: 41,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                child: Text(appLocal.look_for_space),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }

  Widget _getHistoryUI() {
    return Container(
      padding: EdgeInsets.all(15),
      // height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: _parkings
            .map((ParkingModel? p) => _getHistoryCard(context, p!))
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _parkingService.getAllParkings().then((parkings) {
      setState(() {
        _parkings = parkings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  appLocal!.parking_history,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                _parkings.isNotEmpty
                    ? _getHistoryUI()
                    : _getNoHistoryUI(appLocal)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
