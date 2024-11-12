import 'dart:core';

import 'package:flutter/material.dart';
import 'package:vut_itu/trip/place_model.dart';

class SelectedPlacesViewModel extends ChangeNotifier {
  List<PlaceModel> _selectedPlaces = [];

  List<PlaceModel> get all => List.unmodifiable(_selectedPlaces);

  bool hasAny() {
    return _selectedPlaces.isNotEmpty;
  }

  void addPlace(PlaceModel place) {
    if (_selectedPlaces.contains(place)) {
      return;
    }

    _selectedPlaces.add(place);
    notifyListeners();
  }

  void removePlace(PlaceModel place) {
    _selectedPlaces.remove(place);
    notifyListeners();
  }
}
