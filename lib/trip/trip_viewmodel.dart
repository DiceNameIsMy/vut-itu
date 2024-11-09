import 'package:flutter/material.dart';
import 'package:vut_itu/trip/trip.dart';

class TripViewmodel extends ChangeNotifier {
  TripViewmodel(this.tripModel);

  TripModel tripModel;

  String get id => tripModel.id;
  String? get title => tripModel.title;

  set title(String? newTitle) {
    if (tripModel.title != newTitle) {
      tripModel.title = newTitle;
      notifyListeners();
    }
  }
}
