import 'package:flutter/material.dart';
import 'package:vut_itu/trip/trip.dart';  
import 'package:vut_itu/trip/place_model.dart';  
import 'package:vut_itu/backend/trips_backend.dart';

class TripViewModel extends ChangeNotifier {
  final TripModel _tripModel;
  final TripsBackend _tripsBackend = TripsBackend();

  // Constructor
  TripViewModel(this._tripModel);

  // Getters for trip properties
  String get id => _tripModel.id;
  String? get title => _tripModel.title;
  DateTime? get date => _tripModel.date;
  List<PlaceModel> get places => _tripModel.places;

   

  Future<void> setTitle(String newTitle) async {
    bool success = await _tripsBackend.setTitle(id, newTitle);

    if (success) {
      _tripModel.title = newTitle;
      notifyListeners();
    } else {
      // Handle error (optional)
      print("Failed to remove trip");
    }
  }


  Future<void> setDate(DateTime newDate) async {
    bool success = await _tripsBackend.setDate(id, newDate);

    if (success) {
      _tripModel.date = newDate;
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
    _tripModel.date = updatedTripModel.date;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to get the trip model for backend operations (e.g., saving or deleting)
  TripModel get tripModel => _tripModel;
}
