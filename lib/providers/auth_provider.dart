import 'package:flutter/foundation.dart';
import 'package:user_app_yourspacekh/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  int _authStatus = 0;
  int get authStatus => _authStatus;
  UserModel? _user;
  UserModel? get user => _user;

  initialize(UserModel? user) async {
    _user = user;
    if (user!.name == null && user.phoneNumber != null) {
      _authStatus = 1;
    } else if (user.name!.isNotEmpty && user.phoneNumber!.isNotEmpty) {
      _authStatus = 2;
    }
    notifyListeners();
  }
}
