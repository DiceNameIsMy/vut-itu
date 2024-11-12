import 'package:flutter/material.dart';
import 'package:vut_itu/trip/trip.dart';
import 'package:vut_itu/trip/place_model.dart';

class TripViewModel extends ChangeNotifier {
  TripViewModel(this.tripModel);

  TripModel tripModel;

  String get id => tripModel.id;
  String? get title => tripModel.title;
  DateTime? get date => tripModel.date;
  List<PlaceModel> get places => tripModel.places;

  // Set or update the title
  set title(String? newTitle) {
    if (tripModel.title != newTitle) {
      tripModel.title = newTitle;
      notifyListeners();
    }
  }

  // Set or reset the date
  set date(DateTime? newDate) {
    if (tripModel.date != newDate) {
      tripModel.date = newDate;
      notifyListeners();
    }
  }

  // Add a city to the trip
  void addCity(PlaceModel city) {
    if (!tripModel.places.contains(city)) {
      tripModel.places.add(city);
      notifyListeners();
    }
  }

  // Remove a city from the trip
  void removeCity(PlaceModel city) {
    if (tripModel.places.contains(city)) {
      tripModel.places.remove(city);
      notifyListeners();
    }
  }

  // Get the list of cities
  List<PlaceModel> getCities() {
    return tripModel.places;
  }
}

