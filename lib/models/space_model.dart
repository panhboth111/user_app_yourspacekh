import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpaceModel {
  final String id, name, price, address, openTime, closeTime;
  final LatLng coordinate;
  const SpaceModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.address,
      required this.openTime,
      required this.closeTime,
      required this.coordinate});
  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
        id: json['id'],
        name: json['name'],
        price: "N/A",
        address: json["address"],
        openTime: "N/A",
        closeTime: "N/A",
        coordinate: LatLng(json['lat'], json['lng']));
  }
}
