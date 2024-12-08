import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/backend/visiting_place_backend.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  static final _backend = TripsBackend();
  static final _vistingPlaces = VisitingPlaceBackend();
  List<(TripModel, List<VisitingPlaceModel>)> _trips = [];

  TripsCubit() : super(TripsInitial([]));

  Future<void> fetchTrips() async {
    // Set state as loading
    emit(TripsLoading(_trips));

    // Fetch trips from the backend
    var trips = await _backend.getTrips();

    var futures = <Future>[];
    for (var trip in trips) {
      futures.add(_vistingPlaces
          .getVisitingPlaces(trip.id)
          .then((places) => _trips.add((trip, places))));
    }
    await Future.wait(futures);

    emit(TripsShown(_trips));
  }

  Future<void> createTrip(String title) async {
    // Create a new trip
    final newTrip =
        TripModel(id: Uuid().v7(), title: title, arriveAt: null, places: []);

    await _backend.saveTrip(newTrip);
    _trips.add((newTrip, []));

    // Fetch the updated list of trips
    await fetchTrips();
  }
}
