import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:user_app_yourspacekh/constants.dart';

import 'package:user_app_yourspacekh/models/space_model.dart';

class SpaceService {
  Set<SpaceModel> _parseSpaceModels(String resBody) {
    final parsed = convert.jsonDecode(resBody).cast<String, dynamic>();
    return parsed['data']
        .map<SpaceModel>((json) => SpaceModel.fromJson(json))
        .toSet();
  }

  Future<Set<SpaceModel>> getSpaces() async {
    try {
      final url = Uri.parse(kBaseUrl + '/spaces');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return _parseSpaceModels(response.body);
      }
      return {};
    } catch (e) {
      throw "Unable to Request Data";
    }
  }
}
