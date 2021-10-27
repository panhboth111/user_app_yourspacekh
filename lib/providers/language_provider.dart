import 'package:flutter/material.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _locale = null;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    print("triggered");
    if (!L10n.all.contains(locale)) return;
    print("setting");
    _locale = locale;
    notifyListeners();
  }
}
