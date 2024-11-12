import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';

class TripsBackend {
  static final TripsBackend _instance = TripsBackend._internal();

  final List<TripModel> _trips = [
    TripModel(id: Uuid().v7(), title: 'Destination 1'),
    TripModel(id: Uuid().v7(), title: 'Destination 2'),
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

  Future<bool> tryCreateTrip(String? title) async {
    await Future.delayed(Duration(milliseconds: 300)); // Mock delay

    final newTrip = TripModel(id: Uuid().v7(), title: title);
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
}
