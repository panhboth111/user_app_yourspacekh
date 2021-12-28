import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/models/user_model.dart';

class ParkingModel {
  String? id, interval,preferredDate,  plateNumber, plateNumberCity,spaceId, price, status, spaceName;

  UserModel? user;
  SpaceModel? space;
  ParkingModel(
      {this.id,
      this.spaceName,
      this.interval,
      this.preferredDate,
      this.spaceId,
      this.user,
      this.space,
      this.status,
      this.plateNumber,
      this.plateNumberCity,
      this.price,
      
      });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    var userData = json['user'];
    var spaceData = json['space'];

    return ParkingModel(
        id: json['id'].toString(),
        spaceName: json['space']['name'],
        interval: json['interval'],
        preferredDate: json['preferredDate'],
        price: json['price'],
        spaceId: json['spaceId'].toString(),
        status: json['status'],
        plateNumber: json['plateNumber'],
        plateNumberCity: json['plateNumberCity'],
        user: UserModel(
            name: userData['name'],
            id: userData['id'].toString(),
            phoneNumber: userData['phoneNumber']),
        space: SpaceModel(
            id: spaceData['id'],
            name: spaceData['name'],
            price: spaceData['price'],
            address: spaceData['address'],
            coordinate: LatLng(
                spaceData['coordinate']['x'], spaceData['coordinate']['y']),
            openTime: spaceData['openTime'],
            closeTime: spaceData['closeTime']));
  }
}
