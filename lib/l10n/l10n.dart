import 'package:flutter/material.dart';

class L10n {
  static final all = [
    Locale('en'),
    Locale('km'),
  ];
  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'km':
        return 'ភាសាខ្មែរ';
      default:
        return 'English';
    }
  }
}
