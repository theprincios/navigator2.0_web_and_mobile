class PlaceSearch {
  final String city;
  final String addressName;
  final PlacePoint point;

  PlaceSearch(
      {required this.city, required this.addressName, required this.point});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    final point = PlacePoint.fromJson(json['point']);
    return PlaceSearch(
      city: "Vitulano",
      addressName: json['addressName'],
      point: point,
    );
  }
}

class PlacePoint {
  final double latitude;
  final double longitude;

  PlacePoint({required this.latitude, required this.longitude});

  factory PlacePoint.fromJson(Map<String, dynamic> json) {
    return PlacePoint(latitude: json['latitude'], longitude: json['longitude']);
  }
}
