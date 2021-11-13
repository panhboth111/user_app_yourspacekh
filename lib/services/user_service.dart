import 'package:user_app_yourspacekh/models/user_model.dart';

class UserService {
  UserModel _parseUserModel(String? resBody) {
    Map<String, dynamic> json = {
      'id': '123',
      'name': 'Neak Panhboth',
      'phoneNumber': '085248484',
      'language': 'en'
    };
    return UserModel.fromJson(json);
  }

  Future<UserModel?> getUserInformation() async {
    return _parseUserModel("");
  }
}
