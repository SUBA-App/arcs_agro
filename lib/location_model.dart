
import 'package:floor/floor.dart';

@entity
class LocationModel {
  @primaryKey
  int? id;
  String latitude;
  String longitude;
  String createdAt;

  LocationModel(this.latitude, this.longitude, this.createdAt);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'created_at': createdAt,
  };
}