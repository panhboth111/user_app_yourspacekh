import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// utility class for making http requests because it's such a pain in the ass
class HttpRequest {
  static String baseURL = 'http://128.199.229.32:8081';
  static postRequest(
      String endPoint, bool isPrivateRoute, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = "";
    String refreshToken = "";
    try {
      if (isPrivateRoute) {
        refreshToken = prefs.getString("refreshToken")!;
        if (refreshToken.isEmpty) {
          return {
            'success': false,
            'body': null,
            'errors': 'Session expired please login again'
          };
        }
        accessToken = prefs.getString("accessToken")!;
      }

      final url = Uri.parse(baseURL + endPoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.post(url,
          headers: headers, body: convert.jsonEncode(requestBody));
      if (response.statusCode == 401) {
        final res = await _handleRefreshToken(refreshToken);
        if (res['success']) {
          prefs.setString('accessToken', res['body']['accessToken']);

          return postRequest(endPoint, isPrivateRoute, requestBody);
        }
        return res;
      }
      return response.statusCode == 200 || response.statusCode == 201
          ? {
              'success': true,
              'body': response.body.isNotEmpty
                  ? convert.jsonDecode(response.body)
                  : null,
              'errors': ''
            }
          : {
              'success': false,
              'body': null,
              'errors': convert.jsonDecode(response.body)['errors']['message']
            };
    } catch (e) {
      return {'success': false, 'body': null, 'errors': e.toString()};
    }
  }

  static getRequest(String endPoint, bool isPrivateRoute) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = "";
    String? refreshToken = "";
    //check if the access token and refresh token exists
    if (isPrivateRoute) {
      refreshToken = prefs.getString("refreshToken");
      if (refreshToken == null || refreshToken.isEmpty) {
        return {
          'success': false,
          'body': null,
          'errors': 'Session expired please login again'
        };
      }
      accessToken = prefs.getString("accessToken")!;
    }

    final url = Uri.parse(baseURL + endPoint);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 401) {
      final res = await _handleRefreshToken(refreshToken);
      if (res['success']) {
        prefs.setString('accessToken', res['body']['accessToken']);

        return getRequest(endPoint, isPrivateRoute);
      }
      return res;
    }

    return {
      'success': true,
      'body': convert.jsonDecode(response.body),
      'error': null
    };
  }

  static patchRequest(
      String endPoint, bool isPrivateRoute, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = "";
    String refreshToken = "";
    try {
      if (isPrivateRoute) {
        refreshToken = prefs.getString("refreshToken")!;
        if (refreshToken.isEmpty) {
          return {
            'success': false,
            'body': null,
            'errors': 'Session expired please login again'
          };
        }
        accessToken = prefs.getString("accessToken")!;
      }

      final url = Uri.parse(baseURL + endPoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.patch(url,
          headers: headers, body: convert.jsonEncode(requestBody));
      if (response.statusCode == 401) {
        final res = await _handleRefreshToken(refreshToken);
        if (res['success']) {
          prefs.setString('accessToken', res['body']['accessToken']);

          return postRequest(endPoint, isPrivateRoute, requestBody);
        }
        return res;
      }
      return response.statusCode == 200
          ? {
              'success': true,
              'body': convert.jsonDecode(response.body),
              'errors': ''
            }
          : {
              'success': false,
              'body': null,
              'errors': convert.jsonDecode(response.body)['errors']['message']
            };
    } catch (e) {
      return {'success': false, 'body': null, 'errors': e.toString()};
    }
  }

  static putRequest(
      String endPoint, bool isPrivateRoute, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = "";
    String refreshToken = "";
    try {
      if (isPrivateRoute) {
        refreshToken = prefs.getString("refreshToken")!;
        if (refreshToken.isEmpty) {
          return {
            'success': false,
            'body': null,
            'errors': 'Session expired please login again'
          };
        }
        accessToken = prefs.getString("accessToken")!;
      }
      print(accessToken);
      final url = Uri.parse(baseURL + endPoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.put(url,
          headers: headers, body: convert.jsonEncode(requestBody));

      if (response.statusCode == 401) {
        final res = await _handleRefreshToken(refreshToken);
        if (res['success']) {
          prefs.setString('accessToken', res['body']['accessToken']);

          return putRequest(endPoint, isPrivateRoute, requestBody);
        }
        return res;
      }
      return response.statusCode == 200 || response.statusCode == 201
          ? {
              'success': true,
              'body': convert.jsonDecode(response.body),
              'errors': ''
            }
          : {
              'success': false,
              'body': null,
              'errors': convert.jsonDecode(response.body)['errors']['message']
            };
    } catch (e) {
      return {'success': false, 'body': null, 'errors': e.toString()};
    }
  }

  static _handleRefreshToken(String refreshToken) async {
    final url = Uri.parse(baseURL + '/auth/token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(url,
        headers: headers,
        body: convert.jsonEncode({'refreshToken': refreshToken}));
    if (response.statusCode != 200) {
      return {
        'success': false,
        'body': null,
        'error': 'Token expired. Please login again'
      };
    }
    return {
      'success': true,
      'body': convert.jsonDecode(response.body),
      'error': null
    };
  }
}
