import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  late Location _location;
  Location get location => _location;
  LatLng? _locationPosition;
  LatLng? get locationPosition => _locationPosition;
  LocationProvider() {
    _location = new Location();
  }
  initialize() async {
    await this.getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("service not enabled");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("service not allowed");
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("no permission");
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("permission not granted");
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      notifyListeners();
    });
  }
}
