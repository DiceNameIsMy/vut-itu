import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/backend/place_model.dart';
import 'package:vut_itu/backend/trip_model.dart';

class AltTripViewModel extends ChangeNotifier {
  final TripsBackend _tripsBackend = TripsBackend();

  final String tripId;

  late TripModel _tripModel;

  // Constructor
  AltTripViewModel(this.tripId);

  // Getters for trip properties
  String get id => _tripModel.id;
  String get title => _tripModel.title ?? "Unnamed Trip";
  DateTime? get arriveAt => _tripModel.arriveAt;
  List<PlaceModel> get places => _tripModel.places;

  Future<bool> loadTrip() async {
    await Future.delayed(Duration(seconds: 2));

    final tripModel = await _tripsBackend.getTrip(tripId);
    if (tripModel == null) {
      print("Failed to load trip with id $tripId");
      return false;
    }

    _tripModel = tripModel;

    notifyListeners();
    return true;
  }

  Future<void> setTitle(String newTitle) async {
    bool success = await _tripsBackend.setTitle(id, newTitle);

    if (success) {
      _tripModel.title = newTitle;
      notifyListeners();
    } else {
      print("Failed to remove trip");
    }
  }

  Future<void> setDate(DateTime newDate) async {
    bool success = await _tripsBackend.setDate(id, newDate);

    if (success) {
      _tripModel.arriveAt = newDate;
      notifyListeners();
    } else {
      // Handle error (optional)
      print("Failed to remove trip");
    }
  }

  // Method to add a place to the trip
  void addPlace(PlaceModel place) {
    _tripModel.places.add(place);
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to remove a place from the trip
  void removePlace(PlaceModel place) {
    _tripModel.places.remove(place);
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to clear all places (e.g., if the user wants to start fresh)
  void clearPlaces() {
    _tripModel.places.clear();
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to get a specific place by index
  PlaceModel getPlace(int index) {
    return _tripModel.places[index];
  }

  // Method to set a specific place by index
  void setPlace(int index, PlaceModel place) {
    _tripModel.places[index] = place;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to return the total number of places
  int get placesCount => _tripModel.places.length;

  // Method to update the trip model directly (useful for syncing with backend)
  void updateTripModel(TripModel updatedTripModel) {
    _tripModel.title = updatedTripModel.title;
    _tripModel.arriveAt = updatedTripModel.arriveAt;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to get the trip model for backend operations (e.g., saving or deleting)
  TripModel get model => _tripModel;
}
