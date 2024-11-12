import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';

class TripsBackend {
  static final TripsBackend _instance = TripsBackend._internal();

  final List<TripModel> _trips = [
    TripModel(id: Uuid().v7(), title: 'Destination 1', cities: ['Paris']),
    TripModel(id: Uuid().v7(), title: 'Destination 2', cities: ['Tokyo']),
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

  Future<bool> tryCreateTrip({
    String? title,
    DateTime? date,
    required List<String> cities,
  }) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay

    if (cities.isEmpty) {
      return false; // Ensure cities list is not empty
    }

    final newTrip = TripModel(
      id: Uuid().v7(),
      title: title,
      date: date,
      cities: cities,
    );
    _trips.add(newTrip);

    return true;
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
  Future<bool> addCity(String id, String city) async {
    final trip = await getTrip(id);
    if (trip != null) {
      if (!trip.cities.contains(city)) {
        trip.cities.add(city);
        return true;
      }
    }
    return false;
  }

  // Remove a city from a specific trip
  Future<bool> removeCity(String id, String city) async {
    final trip = await getTrip(id);
    if (trip != null) {
      if (trip.cities.contains(city)) {
        trip.cities.remove(city);
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
  Future<List<String>?> getCities(String id) async {
    final trip = await getTrip(id);
    if (trip != null) {
      return trip.cities;
    }
    return null;
  }
}
