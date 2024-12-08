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

  TripsCubit() : super(TripsInitial([]));

  Future<void> fetchTrips() async {
    if (state is TripsLoading) return;

    // Set state as loading
    emit(TripsLoading(state.trips));

    // Fetch trips from the backend
    var trips = await _backend.getTrips();
    state.trips.clear();

    // TODO: Indexing might be off. Sort them.
    var futures = <Future>[];
    for (var trip in trips) {
      futures.add(_vistingPlaces
          .getVisitingPlaces(trip.id)
          .then((places) => state.trips.add((trip, places))));
    }
    await Future.wait(futures);

    emit(TripsLoaded(state.trips));
  }

  Future<void> createTrip(String title) async {
    emit(TripsLoading(state.trips));

    // Create a new trip
    final newTrip =
        TripModel(id: Uuid().v7(), title: title, arriveAt: null, places: []);

    await _backend.saveTrip(newTrip);
    state.trips.add((newTrip, []));

    // Fetch the updated list of trips
    await fetchTrips();
  }
}
