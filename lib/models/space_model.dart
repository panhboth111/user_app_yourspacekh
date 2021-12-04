import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpaceModel {
  final int id;
  final String name, price, address, openTime, closeTime;
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
    double lat = json['coordinate']['x'].runtimeType == int
        ? json['coordinate']['x'].toDouble()
        : json['coordinate']['x'];
    double lng = json['coordinate']['y'].runtimeType == int
        ? json['coordinate']['y'].toDouble()
        : json['coordinate']['y'];
    return SpaceModel(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        address: json["address"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        coordinate: LatLng(lat, lng));
  }
}
