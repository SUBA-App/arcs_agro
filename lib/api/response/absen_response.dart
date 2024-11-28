

class AbsenResponse {
  bool error;
  String message;
  List<AbsenResult> result;

  AbsenResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory AbsenResponse.fromJson(Map<String, dynamic> json) => AbsenResponse(
    error: json["error"],
    message: json["message"],
    result: List<AbsenResult>.from(json['result'].map((e) => AbsenResult.fromJson(e)))
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': List<dynamic>.from(result.map((e) => e.toJson()))
  };
}

class AbsenResult {
  String id;
  int status;
  String checkIn;
  String checkOut;
  String checkInTime;
  String checkOutTime;
  String picture;
  List<Coordinate> coordinates;

  AbsenResult({required this.id, required this.status, required this.checkIn, required this.checkOut,required this.checkInTime, required this.checkOutTime, required this.picture, required this.coordinates});

  factory AbsenResult.fromJson(Map<String, dynamic> json) => AbsenResult(
    id: json["id"],
    status: json['status'],
    checkIn: json['check_in'],
    checkOut: json['check_out'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
    picture: json['picture'],
    coordinates: List<Coordinate>.from(json['coordinates'].map((e) => Coordinate.fromJson(e)))
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    'check_in': checkIn,
    'check_out': checkOut,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
    'picture':picture,
    'coordinates': List<dynamic>.from(coordinates.map((e) => e.toJson()))
  };
}

class Coordinate {
  String coordinate;
  String time;
  int status;

  Coordinate({required this.coordinate, required this.time, required this.status});

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
      coordinate: json["coordinate"],
      time: json['time'],
    status: json['status']
  );

  Map<String, dynamic> toJson() => {
    "coordinate": coordinate,
    "time": time,
    'status': status
  };
}