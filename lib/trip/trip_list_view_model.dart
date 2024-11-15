import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/trip/trip_view_model.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';

class TripListViewModel extends ChangeNotifier {
  TripListViewModel();

  final TripsBackend _tripsBackend = TripsBackend();

  List<TripViewModel> _trips = [];

  List<TripViewModel> get trips => _trips;

  // Future<void> addTrip(TripViewModel trip) async {
  //   // Get the list of cities from the trip ViewModel
  //   List<PlaceModel> places = trip.places;

  //   // Create the trip in the backend with cities and title
  //   TripModel success = await _tripsBackend.tryCreateTrip(places: places);

  //   if (success) {
  //     // If trip creation was successful, add it to the local list
  //     _trips.add(trip);
  //     notifyListeners();
  //   } else {
  //     // Handle error (optional)
  //     print("Failed to add trip");
  //   }
  // }

  Future<TripViewModel> createTripFromSelectedPlaces(
      SelectedPlacesViewModel selectedPlaces) async {
    // Check if there are selected places
    if (selectedPlaces.hasAny()) {
      // Set initial trip details
      final title = "New Trip";
      final date = DateTime.now();
      final places = selectedPlaces.all.map((place) => place).toList();

      // Call backend to create the trip and get the TripModel with ID
      final tripModel = await _tripsBackend.tryCreateTrip(
        title: title,
        date: date,
        places: places,
      );

      // Create a TripViewModel using the complete TripModel returned by the backend
      final newTrip = TripViewModel(tripModel);

      _trips.add(newTrip); // Add the new TripViewModel to the local list
      notifyListeners();

      return newTrip; // Return the new TripViewModel with a consistent ID
    }

    throw Exception("Failed to create trip: No selected places.");
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

  // Function to update the title of a specific trip
  // Future<void> updateTripTitle(String tripId, String newTitle) async {

  //   final trip = _trips.firstWhere((trip) => trip.id == tripId, orElse:  () => TripViewModel(TripModel(id: '', title: '', date: DateTime.now(), places: [])));

  //     bool success = await _tripsBackend.setTitle(tripId, newTitle);
  //     if (success) {
  //       // Update the title locally
  //       trip. = newTitle;
  //       notifyListeners();
  //     } else {
  //       print("Failed to update trip title");
  //     }

  // }

//     Future<void> updateTripDate(String tripId, DateTime newDate) async {
//   // Find the trip by ID
//   final trip = _trips.firstWhere(
//     (trip) => trip.id == tripId,
//     orElse: () => TripViewModel(TripModel(id: '', title: '', date: DateTime.now(), places: [])), // Default/fallback
//   );

//   if (trip.id.isNotEmpty) { // Ensure it is a valid trip before proceeding
//     // Update the date in the backend
//     bool success = await _tripsBackend.setDate(tripId, newDate);
//     if (success) {
//       // Update the date locally
//       trip.date = newDate;
//       notifyListeners();
//     } else {
//       print("Failed to update trip date");
//     }
//   } else {
//     print("Trip not found");
//   }
// }
}
