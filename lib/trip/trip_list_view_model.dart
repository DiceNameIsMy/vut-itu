import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/trip/trip_view_model.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';
import 'package:vut_itu/trip/trip.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/place_model.dart';

class TripListViewModel extends ChangeNotifier {
  TripListViewModel();

  final TripsBackend _tripsBackend = TripsBackend();

  List<TripViewModel> _trips = [];

  List<TripViewModel> get trips => _trips;

  Future<void> addTrip(TripViewModel trip) async {
    // Get the list of cities from the trip ViewModel
    List<PlaceModel> places = trip.places;

    // Create the trip in the backend with cities and title
    bool success = await _tripsBackend.tryCreateTrip(places: places);

    if (success) {
      // If trip creation was successful, add it to the local list
      _trips.add(trip);
      notifyListeners();
    } else {
      // Handle error (optional)
      print("Failed to add trip");
    }
  }

   Future<TripViewModel> createTripFromSelectedPlaces(SelectedPlacesViewModel selectedPlaces) async {
  // Check if there are selected places
  if (selectedPlaces.hasAny()) {
    // Create a new trip from selected places (cities)
    final newTrip = TripViewModel(
      TripModel(
        id: Uuid().v7(),
        title: "New Trip", // Can be customized if needed
        date: DateTime.now(), // Can be customized
        places: selectedPlaces.all.map((place) => place).toList(),
      ),
    );

    // Add the trip to the backend and the local list
    bool success = await _tripsBackend.tryCreateTrip(
      title: newTrip.title,
      date: newTrip.date,
      places: newTrip.places,
    );

    if (success) {
      _trips.add(newTrip);
      notifyListeners();
      return newTrip; // Return the id of the newly created trip
    } else {
      print("Failed to create trip");
      throw Exception("Failed to create trip");
    }
  }

    throw Exception("Failed to create trip");
}


  Future<void> removeTrip(TripViewModel trip) async {
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
