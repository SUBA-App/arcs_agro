import 'package:geolocator/geolocator.dart';

class LocationResult {
  int type;
  String message;
  Position? position;

  LocationResult({required this.type, required this.message, required this.position});
}