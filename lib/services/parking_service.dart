import 'package:user_app_yourspacekh/models/parking_model.dart';
import 'package:user_app_yourspacekh/utils/http_request.dart';

class ParkingService {
  createParking(ParkingModel parking) async {
    var requestBody = {
      'interval': parking.interval,
      'preferredDate': parking.preferredDate,
      'spaceId': parking.spaceId
    };
    print(requestBody);
    var response =
        await HttpRequest.postRequest("/parkings", true, requestBody);
    print(response);
  }

  getCurrentParking() async {
    var response = await HttpRequest.getRequest(
        "/parkings?status=BOOKING&status=ACCEPTED&status=DONE", true);
    return response;
  }
}
