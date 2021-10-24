import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthed = false;
  bool get isAuthed => _isAuthed;
  int _count = 0;
  int get count => _count;
  increment() {
    _count++;
    notifyListeners();
  }
}
