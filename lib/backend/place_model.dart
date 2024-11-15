import 'package:latlong2/latlong.dart';

// Represents a place on a map, unrelated to any trip
class PlaceModel {
  final String id;
  final String title;
  final String description;
  final LatLng coordinates;
  final DateTime? arriveAt;
  final String imageUrl;

  PlaceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.arriveAt,
    required this.imageUrl,
  });
}
