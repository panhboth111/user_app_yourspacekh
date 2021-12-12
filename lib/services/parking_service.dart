import 'package:user_app_yourspacekh/models/parking_model.dart';
import 'package:user_app_yourspacekh/utils/http_request.dart';

class ParkingService {
  Set<ParkingModel> _parseSpaceModels(dynamic resBody) {
    return resBody
        .map<ParkingModel>((json) => ParkingModel.fromJson(json))
        .toSet();
  }

  createParking(ParkingModel parking) async {
    var requestBody = {
      'interval': parking.interval,
      'preferredDate': parking.preferredDate,
      'spaceId': parking.spaceId
    };
    var response =
        await HttpRequest.postRequest("/parkings", true, requestBody);

    return response;
  }

  cancelParking(String id) async {
    Map<String, dynamic> requestBody = {};
    var response = await HttpRequest.putRequest(
        "/parkings/" + id + "/cancel", true, requestBody);
    print(response);
    if (response['success']) {
      return false;
    }
    return true;
  }

  getCurrentParking() async {
    var response = await HttpRequest.getRequest(
        "/parkings?status=BOOKING&status=ACCEPTED&status=PARKING", true);
    return response;
  }

  getAllParkings() async {
    var response = await HttpRequest.getRequest("/parkings", true);
    var result = _parseSpaceModels(response['body']['data']);
    return result;
  }
}
