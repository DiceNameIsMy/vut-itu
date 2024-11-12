import 'package:vut_itu/trip/place_model.dart';
class TripModel {
  TripModel({
    required this.id,
    this.title,
    this.date,
    required this.places,
  }) : assert(places.isNotEmpty, 'Places list cannot be empty.');

  final String id;
  String? title;
  DateTime? date;
  final List<PlaceModel> places;
}
