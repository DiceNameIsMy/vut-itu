import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';
import 'package:vut_itu/trip/place_model.dart';
import 'package:latlong2/latlong.dart';

class TripsBackend {
  static final TripsBackend _instance = TripsBackend._internal();

  List<TripModel> _trips = [
  TripModel(
    id: Uuid().v7(),
    title: 'Destination 1',
    places: [
      PlaceModel(
        id: 'place1',
        title: 'Paris',
        description: 'Capital city of France',
        coordinates: LatLng(48.8566, 2.3522), // Example coordinates for Paris
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
        imageUrl: 'https://example.com/tokyo.jpg',
      ),
    ],
  ),
];

  factory TripsBackend() {
    return _instance;
  }

  TripsBackend._internal();

  Future<List<TripModel>> getTrips() async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay
    return _trips;
  }

  Future<TripModel?> getTrip(String id) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay
    return _trips.where((trip) => trip.id == id).firstOrNull;
  }

  Future<TripModel> tryCreateTrip({
  required String title,
  required DateTime date,
  required List<PlaceModel> places,
}) async {
  await Future.delayed(Duration(milliseconds: 300)); // Mock delay

  if (places.isEmpty) {
    throw Exception("Places list cannot be empty");
  }

  // Generate a single trip model with a consistent ID
  final newTrip = TripModel(
    id: Uuid().v7(),
    title: title,
    date: date,
    places: places,
  );

  _trips.add(newTrip); // Add to the backend's trip list

  return newTrip; // Return the complete trip model instead of just a success boolean
}


  Future<bool> tryDeleteTrip(String? id) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay

    final lenBefore = _trips.length;

    _trips.removeWhere((trip) => trip.id == id);

    final lenAfter = _trips.length;
    return lenBefore != lenAfter;
  }

  // Set or reset title for a specific trip
  Future<bool> setTitle(String id, String? title) async {
    final trip = await getTrip(id);
    if (trip != null) {
      trip.title = title;
      return true;
    }
    return false;
  }

  // Add a city to a specific trip
  Future<bool> addCity(String id, PlaceModel city) async {
    final trip = await getTrip(id);
    if (trip != null) {
      if (!trip.places.contains(city)) {
        trip.places.add(city);
        return true;
      }
    }
    return false;
  }

  // Remove a city from a specific trip
  Future<bool> removeCity(String id, PlaceModel city) async {
    final trip = await getTrip(id);
    if (trip != null) {
      if (trip.places.contains(city)) {
        trip.places.remove(city);
        return true;
      }
    }
    return false;
  }

  // Set or reset the date for a specific trip
  Future<bool> setDate(String id, DateTime? date) async {
    final trip = await getTrip(id);
    if (trip != null) {
      trip.date = date;
      return true;
    }
    return false;
  }

  // Get the list of cities for a specific trip
  Future<List<PlaceModel>?> getCities(String id) async {
    final trip = await getTrip(id);
    if (trip != null) {
      return trip.places;
    }
    return null;
  }
}
