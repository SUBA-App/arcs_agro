

class AbsenResponse {
  bool error;
  String message;
  AbsenResult result;

  AbsenResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory AbsenResponse.fromJson(Map<String, dynamic> json) => AbsenResponse(
    error: json["error"],
    message: json["message"],
    result: AbsenResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result
  };
}

class AbsenResult {
  List<AbsenData> results;
  int currentPage;
  int total;
  int lastPage;

  AbsenResult({required this.results, required this.currentPage, required this.total, required this.lastPage});

  factory AbsenResult.fromJson(Map<String, dynamic> json) => AbsenResult(
      results:  List<AbsenData>.from(json['data'].map((e) => AbsenData.fromJson(e))),
      currentPage: json['current_page'],
      total: json['total'],
      lastPage: json['last_page']
  );

  Map<String,dynamic> toJson() => {
    'data':List<dynamic>.from(results.map((e) => e.toJson())),
    'current_page': currentPage,
    'total': total,
    'last_page': lastPage
  };
}

class AbsenData {
  String id;
  int status;
  String checkIn;
  String checkOut;
  String checkInTime;
  String checkOutTime;
  List<String> pictures;
  String storeName;

  AbsenData({required this.id, required this.status, required this.checkIn, required this.checkOut,required this.checkInTime, required this.checkOutTime, required this.pictures, required this.storeName});

  factory AbsenData.fromJson(Map<String, dynamic> json) => AbsenData(
    id: json["id"],
    status: json['status'],
    checkIn: json['check_in'],
    checkOut: json['check_out'],
    checkInTime: json['check_in_time'],
    checkOutTime: json['check_out_time'],
    storeName: json['store_name'],
    pictures: List<String>.from(json['pictures'].map((e) => e)),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    'check_in': checkIn,
    'check_out': checkOut,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
    'store_name': storeName,
    'pictures':List<dynamic>.from(pictures.map((e) => e)),
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

class ImageS {
  String image;

  ImageS({required this.image});

  factory ImageS.fromJson(Map<String, dynamic> json) => ImageS(
      image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}