import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/trip_alternative/alt_trip_card_view_model.dart';

class AltTripListViewModel extends ChangeNotifier {
  final TripsBackend _tripsBackend = TripsBackend();

  AltTripListViewModel();

  List<AltTripCardViewModel> _trips = [];

  List<AltTripCardViewModel> get trips => _trips;

  Future<List<AltTripCardViewModel>> loadTrips() async {
    final trips = await _tripsBackend.getTrips();
    _trips = trips.map((trip) => AltTripCardViewModel(trip)).toList();
    notifyListeners();
    return _trips;
  }

  Future<void> addTrip(String title) async {
    final trip = TripModel(id: Uuid().v7(), title: title);
    _trips.add(AltTripCardViewModel(trip));
    notifyListeners();

    await _tripsBackend.saveTrip(trip);
  }

  Future<void> removeTrip(String tripId) async {
    _trips.removeWhere((trip) => trip.id == tripId);
    notifyListeners();
    await _tripsBackend.tryDeleteTrip(tripId);
  }
}
