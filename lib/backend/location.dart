import 'package:latlong2/latlong.dart';

class Location {
  final String name;

  final String geoapifyId;
  final LocationType locationType;
  final LatLng latLng;

  Location(
      {required this.name,
      required this.geoapifyId,
      required this.locationType,
      required this.latLng});

  factory Location.fromJson(Map<String, dynamic> json) {
    var type = switch (json['result_type'] as String) {
      'city' => LocationType.city,
      'attraction' => LocationType.attraction,
      _ => LocationType.other,
    };
    var geoapifyId = json['place_id'] as String;

    return Location(
      name: json['formatted'] as String,
      geoapifyId: geoapifyId,
      locationType: type,
      latLng: LatLng(json['lat'] as double, json['lon'] as double),
    );
  }
}

enum LocationType {
  city,
  attraction,
  other,
}
