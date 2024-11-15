import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:vut_itu/backend/mocks.dart';
import 'package:vut_itu/backend/place_model.dart';

class PlacesBackend {
  static final List<PlaceModel> _places = mockPlaces.toList();

  Future<List<PlaceModel>> findByTitle(
      String title, int page, int pageSize) async {
    await Future.delayed(Duration(milliseconds: 900)); // Mock delay

    var titleLower = title.toLowerCase();
    var filteredPlaces = _places
        .where((place) => place.title.toLowerCase().contains(titleLower))
        .toList();

    var start = (page - 1) * pageSize;
    var end = start + pageSize;
    return filteredPlaces.sublist(start, min(filteredPlaces.length, end));
  }

  Future<List<PlaceModel>> getRecommendations(int page, int pageSize) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay

    var filteredPlaces = _places.toList();

    var start = (page - 1) * pageSize;
    var end = start + pageSize;
    return filteredPlaces.sublist(
        start, end > filteredPlaces.length ? filteredPlaces.length : end);
  }

  Future<List<PlaceModel>> findByCoordinates(
      LatLng coordinates, double radius) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay

    final distance = Distance();

    return _places.where((place) {
      var km = distance.as(
        LengthUnit.Kilometer,
        coordinates,
        place.coordinates,
      );
      return km <= radius;
    }).toList();
  }
}
