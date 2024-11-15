import 'package:vut_itu/backend/trip_model.dart';

class AltTripCardViewModel {
  final TripModel _trip;

  AltTripCardViewModel(TripModel trip) : _trip = trip;

  String get id => _trip.id;
  String get title => _trip.title ?? "Unnamed Trip";
  DateTime? get arriveAt => _trip.arriveAt;
}
