import 'package:vut_itu/backend/place_model.dart';

class TripModel {
  TripModel({
    required this.id,
    this.title,
    this.arriveAt,
    this.places = const [],
  });

  final String id;
  String? title;
  DateTime? arriveAt;
  final List<PlaceModel> places;
}
