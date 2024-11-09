import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/trip/trip_view_model.dart';

class TripListViewModel extends ChangeNotifier {
  TripListViewModel();

  final TripsBackend _tripsBackend = TripsBackend();

  List<TripViewModel> _trips = [];

  List<TripViewModel> get trips => _trips;

  void addTrip(TripViewModel trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void removeTrip(TripViewModel trip) {
    _trips.remove(trip);
    notifyListeners();
  }

  Future<void> loadTrips() async {
    var models = await (_tripsBackend.getTrips());

    _trips = models.map((trip) => TripViewModel(trip)).toList();

    notifyListeners();
  }
}
