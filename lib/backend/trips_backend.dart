import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';

class TripsBackend {
  static final TripsBackend _instance = TripsBackend._internal();

  factory TripsBackend() {
    return _instance;
  }

  TripsBackend._internal();

  Future<List<TripModel>> getTrips() async {
    await Future.delayed(Duration(seconds: 2)); // Mock loading delay
    return [
      TripModel(id: Uuid().v7(), title: 'Destination 1'),
      TripModel(id: Uuid().v7(), title: 'Destination 2'),
    ];
  }
}
