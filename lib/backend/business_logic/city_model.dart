import 'package:latlong2/latlong.dart';
import 'package:vut_itu/backend/location.dart';

class CityModel {
  int? id;
  String name;
  String country;
  String? description;
  LatLng? coordinates;
  String? imageUrl;
  final String geoapifyId;

  CityModel({
    this.id,
    required this.name,
    required this.country,
    this.description,
    this.coordinates,
    this.imageUrl,
    this.geoapifyId = '',
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
      'geoapify_id': geoapifyId,
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
      geoapifyId: map['geoapify_id'],
    );
  }

  factory CityModel.fromLocation(Location location) {
    return CityModel(
      name: location.name,
      country: location.country,
      description: '',
      coordinates: location.latLng,
      imageUrl: null,
      geoapifyId: location.geoapifyId,
    );
  }
}
