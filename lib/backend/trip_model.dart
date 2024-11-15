import 'package:vut_itu/backend/place_model.dart';

class TripModel {
  TripModel({
    required this.id,
    this.title,
    this.arriveAt,
    required this.places,
  }) : assert(places.isNotEmpty, 'Places list cannot be empty.');

  final String id;
  String? title;
  DateTime? arriveAt;
  final List<PlaceModel> places;
}
