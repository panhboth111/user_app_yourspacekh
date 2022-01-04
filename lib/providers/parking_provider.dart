import 'package:flutter/foundation.dart';
import 'package:user_app_yourspacekh/models/parking_model.dart';

class ParkingProvider extends ChangeNotifier {
  int _bottomCardType = 0;
  int get bottomCardType => _bottomCardType;
  ParkingModel? _currentParking;
  ParkingModel? get currentParking => _currentParking;
  void setCurrentParking(ParkingModel? parking) {
    _currentParking = parking;
    notifyListeners();
  }

  void setBottomCardType(int type) {
    _bottomCardType = type;

    notifyListeners();
  }
}
