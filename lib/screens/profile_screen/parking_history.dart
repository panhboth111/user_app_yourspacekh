import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParkingHistoryScreen extends StatefulWidget {
  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  Widget _getNoHistoryUI(appLocal) {
    return Container(
      margin: EdgeInsets.only(top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 120,
            color: Color(0xffc7c7c7),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              appLocal.no_history,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(left: 70, right: 70),
            child: Text(
              appLocal.no_history_desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 80),
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
    return Container();
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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 25, left: 20, right: 20),
        child: Column(
          children: [
            Text(
              appLocal!.parking_history,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            _getNoHistoryUI(appLocal)
          ],
        ),
      ),
    );
  }
}
