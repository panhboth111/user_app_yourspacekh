import 'package:flutter/foundation.dart';
import 'package:user_app_yourspacekh/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthed = false;
  bool get isAuthed => _isAuthed;
  UserModel? _user;
  UserModel? get user => _user;

  initialize(UserModel? user) async {
    _user = user;
    _isAuthed = true;
    notifyListeners();
  }
}
