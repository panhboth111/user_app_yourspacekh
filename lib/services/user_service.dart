import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app_yourspacekh/models/user_model.dart';
import 'package:user_app_yourspacekh/utils/http_request.dart';

class UserService {
  UserModel _parseUserModel(dynamic resBody) {
    Map<String, dynamic> json = {
      'id': resBody['id'].toString(),
      'name': resBody['name'],
      'phoneNumber': resBody['phoneNumber'],
      'language': 'km'
    };
    return UserModel.fromJson(json);
  }

  Future<UserModel?> getUserInformation() async {
    var response = await HttpRequest.getRequest('/profile', true);

    return response['success']
        ? _parseUserModel(response['body']['data'])
        : UserModel(id: null, name: null, phoneNumber: null, language: "km");
  }

  login(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await HttpRequest.postRequest(
        '/auth/login', false, {'phoneNumber': phoneNumber});

    if (response['success']) {
      prefs.setString('key', response['body']['key']);
    }
    return response;
  }

  verifyPhoneNumber(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString('key')!;
    final response = await HttpRequest.postRequest(
        '/auth/verify', false, {'code': code, 'key': key, 'role': 'user'});
    if (response['success']) {
      prefs.setString('accessToken', response['body']['accessToken']);
      prefs.setString('refreshToken', response['body']['refreshToken']);
    }
    return response;
  }

  registerInformation(String name, dynamic userDetail) async {
    final response = await HttpRequest.patchRequest("/profile", true,
        {"name": name, "language": "km", "userDetail": userDetail});
    return response;
  }
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', "");
    prefs.setString('refreshToken', "");
  }
}
