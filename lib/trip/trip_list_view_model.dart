import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/trip/trip_view_model.dart';

class TripListViewModel extends ChangeNotifier {
  TripListViewModel();

  final TripsBackend _tripsBackend = TripsBackend();

  List<TripViewModel> _trips = [];

  List<TripViewModel> get trips => _trips;

  Future<void> addTrip(TripViewModel trip) async {
    // Get the list of cities from the trip ViewModel
    List<String> cities = trip.cities;

    // Create the trip in the backend with cities and title
    bool success = await _tripsBackend.tryCreateTrip(cities: cities);

    if (success) {
      // If trip creation was successful, add it to the local list
      _trips.add(trip);
      notifyListeners();
    } else {
      // Handle error (optional)
      print("Failed to add trip");
    }
  }

  // Remove a trip from both backend and local list
  Future<void> removeTrip(TripViewModel trip) async {
    // Delete the trip from the backend
    bool success = await _tripsBackend.tryDeleteTrip(trip.id);

    if (success) {
      // If trip deletion was successful, remove it from the local list
      _trips.remove(trip);
      notifyListeners();
    } else {
      // Handle error (optional)
      print("Failed to remove trip");
    }
  }


  Future<void> loadTrips() async {
    var models = await (_tripsBackend.getTrips());

    _trips = models.map((trip) => TripViewModel(trip)).toList();

    notifyListeners();
  }
}
