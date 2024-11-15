import 'package:flutter/material.dart';
import 'package:vut_itu/backend/places_backend.dart';
import 'package:vut_itu/backend/place_model.dart';

class SearchViewModel extends ChangeNotifier {
  String? _searchTerm;
  List<PlaceModel> _foundPlaces = [];

  final PlacesBackend _backend = PlacesBackend();

  List<PlaceModel> get foundPlaces => _foundPlaces;

  Future findByTitle(String title, int page, int pageSize) async {
    if (_searchTerm == title) {
      return _foundPlaces;
    }

    _searchTerm = title;
    _foundPlaces = await _backend.findByTitle(title, page, pageSize);
    notifyListeners();
  }

  Future getRecommendations(int amount) async {
    if (_searchTerm == null && _foundPlaces.isNotEmpty) {
      return;
    }

    _searchTerm = null;
    _foundPlaces = await _backend.getRecommendations(1, 3);
    notifyListeners();
  }
}
