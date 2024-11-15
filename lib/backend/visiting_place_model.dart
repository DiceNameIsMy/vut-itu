import 'package:latlong2/latlong.dart';

// Represents a place to visit on a trip
class VisitingPlaceModel {
  final String id;
  final String placeId;
  final String tripId;
  final String title;
  final String description;
  final LatLng coordinates;
  final DateTime? arriveAt;
  final String imageUrl;

  VisitingPlaceModel({
    required this.id,
    required this.placeId,
    required this.tripId,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.arriveAt,
    required this.imageUrl,
  });
}
