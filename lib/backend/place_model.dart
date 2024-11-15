import 'package:latlong2/latlong.dart';

class PlaceModel {
  final String id;
  final String title;
  final String description;
  final LatLng coordinates;
  final String imageUrl;

  PlaceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.imageUrl,
  });
}
