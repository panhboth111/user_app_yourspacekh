import 'package:flutter/cupertino.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/services/space_service.dart';

class SpaceProvider extends ChangeNotifier {
  final SpaceService _spaceService = SpaceService();
  Set<SpaceModel> spaces = {};

  initialize() async {
    try {
      spaces = await _spaceService.getSpaces();
    } catch (e) {
      rethrow;
    }
  }

  getSpaces() async {
    try {
      spaces = await _spaceService.getSpaces();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
