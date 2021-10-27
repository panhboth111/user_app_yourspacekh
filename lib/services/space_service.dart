import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:user_app_yourspacekh/models/space_model.dart';

class SpaceService {
  List<SpaceModel> _parseSpaceModels(String resBody) {
    final parsed = convert.jsonDecode(resBody).cast<String, dynamic>();
    return parsed['offices']
        .map<SpaceModel>((json) => SpaceModel.fromJson(json))
        .toList();
  }

  Future<List<SpaceModel>?> getSpaces() async {
    var url = Uri.parse('https://about.google/static/data/locations.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return _parseSpaceModels(response.body);
    }
    return null;
  }
}
