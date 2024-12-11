import 'package:latlong2/latlong.dart';

class AttractionModel {
  int id;
  final int cityId;
  final String name;
  final String description;
  final LatLng coordinates;
  final String category;
  final double averageTime;
  final double cost;

  AttractionModel({
    this.id = 0,
    required this.cityId,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.category,
    required this.averageTime,
    required this.cost,
  });

  factory AttractionModel.fromMap(Map<String, dynamic> map) {
    return AttractionModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      cityId: map['city_id'],
      coordinates: LatLng(map['coordinates_lat'], map['coordinates_lng']),
      category: map['category'],
      averageTime: map['average_time'].toDouble(),
      cost: map['cost'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city_id': cityId,
      'coordinates_lat': coordinates.latitude,
      'coordinates_lng': coordinates.longitude,
      'category': category,
      'average_time': averageTime,
      'cost': cost,
    };
  }
}
