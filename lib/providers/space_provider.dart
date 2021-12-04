import 'package:flutter/cupertino.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/services/space_service.dart';

class SpaceProvider extends ChangeNotifier {
  final SpaceService _spaceService = SpaceService();
  Set<SpaceModel> _spaces = {};
  Set<SpaceModel> get spaces => _spaces;
  SpaceModel? _activeSpace;
  SpaceModel? get activeSpace => _activeSpace;

  setActiveSpace(SpaceModel space) {
    _activeSpace = space;
    notifyListeners();
  }

  initialize() async {
    try {
      final response = await _spaceService.getSpaces();
      if (response != null) {
        _spaces = response;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
