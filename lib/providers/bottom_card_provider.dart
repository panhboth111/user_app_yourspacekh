import 'package:flutter/foundation.dart';

class BottomCardProvider extends ChangeNotifier {
  int _bottomCardType = 0;
  int get bottomCardType => _bottomCardType;

  void setBottomCardType(int type) {
    _bottomCardType = type;
    notifyListeners();
  }
}
