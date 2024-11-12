import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/place_model.dart';

class PlacesBackend {
  static final List<PlaceModel> _places = [
    PlaceModel(
      id: Uuid().v7(),
      title: "Prague",
      description: "The capital city of the Czech Republic.",
      coordinates: LatLng(50.0755, 14.4378),
      imageUrl: "https://example.com/prague.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Berlin",
      description: "The capital city of Germany.",
      coordinates: LatLng(52.5200, 13.4050),
      imageUrl: "https://example.com/berlin.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Paris",
      description: "The capital city of France.",
      coordinates: LatLng(48.8566, 2.3522),
      imageUrl: "https://example.com/paris.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "London",
      description: "The capital city of the United Kingdom.",
      coordinates: LatLng(51.5074, -0.1278),
      imageUrl: "https://example.com/london.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Tokyo",
      description: "The capital city of Japan.",
      coordinates: LatLng(35.6895, 139.6917),
      imageUrl: "https://example.com/tokyo.jpg",
    ),
  ];

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
