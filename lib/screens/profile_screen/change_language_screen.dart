import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';
import 'package:user_app_yourspacekh/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguageScreen extends StatelessWidget {
  Widget _getLanguageTile(BuildContext context, Locale locale) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                height: 30,
                width: 30,
                child: Image.asset(
                    "assets/images/" + locale.languageCode + ".png"),
              ),
              Text(
                L10n.getLanguageName(locale.languageCode),
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          Provider.of<LanguageProvider>(context, listen: false)
                      .locale
                      .toString() ==
                  locale.languageCode
              ? Icon(
                  Icons.check,
                  color: Colors.blue,
                )
              : Container()
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
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.change_language,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                  children: L10n.all
                      .map((e) => GestureDetector(
                            onTap: () {
                              Provider.of<LanguageProvider>(context,
                                      listen: false)
                                  .setLocale(new Locale(e.languageCode));
                            },
                            child: _getLanguageTile(context, e),
                          ))
                      .toList())
            ],
          )),
    );
  }
}