class CoordinateBody {
  double latitude;
  double longitude;

  CoordinateBody(this.latitude, this.longitude);

  Map<String,dynamic> toJson() => {
    'latitude': latitude.toString(),
    'longitude': longitude.toString()
  };
}