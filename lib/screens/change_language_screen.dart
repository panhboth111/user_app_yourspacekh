import 'package:flutter/material.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';

class ChangeLanguageScreen extends StatelessWidget {
  Widget _getLanguageTile(Locale locale) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                child: Image.asset(
                    "assets/images/" + locale.languageCode + ".png"),
              ),
              Text(L10n.getLanguageName(locale.languageCode)),
            ],
          ),
          Icon(Icons.check)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "Language",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              Column(
                  children: L10n.all.map((e) => _getLanguageTile(e)).toList())
            ],
          )),
    );
  }
}
