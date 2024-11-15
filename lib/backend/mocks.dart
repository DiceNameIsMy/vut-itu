import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/place_model.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

final List<TripModel> mockTrips = [
  TripModel(
    id: Uuid().v7(),
    title: 'Destination 1',
    places: [
      PlaceModel(
        id: 'place1',
        title: 'Paris',
        description: 'Capital city of France',
        coordinates: LatLng(48.8566, 2.3522), // Example coordinates for Paris
        arriveAt: null,
        imageUrl: 'https://example.com/paris.jpg',
      ),
    ],
  ),
  TripModel(
    id: Uuid().v7(),
    title: 'Destination 2',
    places: [
      PlaceModel(
        id: 'place2',
        title: 'Tokyo',
        description: 'Capital city of Japan',
        coordinates: LatLng(35.6762, 139.6503), // Example coordinates for Tokyo
        arriveAt: null,
        imageUrl: 'https://example.com/tokyo.jpg',
      ),
    ],
  ),
];

final List<PlaceModel> mockPlaces = [
  PlaceModel(
    id: Uuid().v7(),
    title: "Prague",
    description: "The capital city of the Czech Republic.",
    coordinates: LatLng(50.0755, 14.4378),
    arriveAt: null,
    imageUrl: "https://example.com/prague.jpg",
  ),
  PlaceModel(
    id: Uuid().v7(),
    title: "Berlin",
    description: "The capital city of Germany.",
    coordinates: LatLng(52.5200, 13.4050),
    arriveAt: null,
    imageUrl: "https://example.com/berlin.jpg",
  ),
  PlaceModel(
    id: Uuid().v7(),
    title: "Paris",
    description: "The capital city of France.",
    coordinates: LatLng(48.8566, 2.3522),
    arriveAt: null,
    imageUrl: "https://example.com/paris.jpg",
  ),
  PlaceModel(
    id: Uuid().v7(),
    title: "London",
    description: "The capital city of the United Kingdom.",
    coordinates: LatLng(51.5074, -0.1278),
    arriveAt: null,
    imageUrl: "https://example.com/london.jpg",
  ),
  PlaceModel(
    id: Uuid().v7(),
    title: "Tokyo",
    description: "The capital city of Japan.",
    coordinates: LatLng(35.6895, 139.6917),
    arriveAt: null,
    imageUrl: "https://example.com/tokyo.jpg",
  ),
];

final List<VisitingPlaceModel> mockVisitingPlaces = [
  VisitingPlaceModel(
    id: 'place1',
    tripId: mockTrips[0].id,
    placeId: mockPlaces[2].id,
    title: 'Paris',
    description: 'Capital city of France',
    coordinates: LatLng(48.8566, 2.3522), // Example coordinates for Paris
    arriveAt: null,
    imageUrl: 'https://example.com/paris.jpg',
  ),
  VisitingPlaceModel(
    id: 'place2',
    tripId: mockTrips[0].id,
    placeId: mockPlaces[4].id,
    title: 'Tokyo',
    description: 'Capital city of Japan',
    coordinates: LatLng(35.6762, 139.6503), // Example coordinates for Tokyo
    arriveAt: null,
    imageUrl: 'https://example.com/tokyo.jpg',
  ),
];
