import 'package:flutter/material.dart';

class SelectedPlacesViewModel extends ChangeNotifier {
  List<String> _selectedPlaces = [];

  List<String> get all => List.unmodifiable(_selectedPlaces);

  bool hasAny() {
    return _selectedPlaces.isNotEmpty;
  }

  void addPlace(String place) {
    if (_selectedPlaces.contains(place)) {
      return;
    }

    _selectedPlaces.add(place);
    notifyListeners();
  }

  void removePlace(String place) {
    _selectedPlaces.remove(place);
    notifyListeners();
  }
}
