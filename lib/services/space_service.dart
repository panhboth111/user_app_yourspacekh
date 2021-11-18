import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:user_app_yourspacekh/constants.dart';

import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/utils/http_request.dart';

class SpaceService {
  Set<SpaceModel> _parseSpaceModels(dynamic resBody) {
    return resBody.map<SpaceModel>((json) => SpaceModel.fromJson(json)).toSet();
  }

  getSpaces() async {
    try {
      final response =
          await HttpRequest.getRequest("/spaces?nearest=20,20", true);

      if (response['success']) {
        var result = _parseSpaceModels(response['body']['data']);
        return result;
      }
      // if (response.statusCode == 200) {
      //   return _parseSpaceModels(response.body);
      // }
      return null;
    } catch (e) {
      throw "Unable to Request Data";
    }
  }
}
