import 'package:latlong2/latlong.dart';

class CityModel {
  int id;
  String name;
  String country;
  String? description;
  LatLng? coordinates;
  String? imageUrl;

  CityModel({
    this.id = 0,
    required this.name,
    required this.country,
    this.description,
    this.coordinates,
    this.imageUrl,
  });

  // Convert City object to Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'coordinates_lat': coordinates?.latitude,
      'coordinates_lng': coordinates?.longitude,
      'image_url': imageUrl,
    };
  }

  // Convert Map (from database) to City object
  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'],
      name: map['name'],
      country: map['country'],
      description: map['description'],
      coordinates: map['coordinates_lat'] != null
          ? LatLng(map['coordinates_lat'], map['coordinates_lng'])
          : null,
      imageUrl: map['image_url'],
    );
  }
}
