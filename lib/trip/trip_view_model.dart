import 'package:flutter/material.dart';
import 'package:vut_itu/trip/trip.dart';

class TripViewModel extends ChangeNotifier {
  TripViewModel(this.tripModel);

  TripModel tripModel;

  String get id => tripModel.id;
  String? get title => tripModel.title;
  DateTime? get date => tripModel.date;
  List<String> get cities => tripModel.cities;

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
  void addCity(String city) {
    if (!tripModel.cities.contains(city)) {
      tripModel.cities.add(city);
      notifyListeners();
    }
  }

  // Remove a city from the trip
  void removeCity(String city) {
    if (tripModel.cities.contains(city)) {
      tripModel.cities.remove(city);
      notifyListeners();
    }
  }

  // Get the list of cities
  List<String> getCities() {
    return tripModel.cities;
  }
}

