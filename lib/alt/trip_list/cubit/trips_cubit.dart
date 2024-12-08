import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/backend/visiting_place_backend.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  static final _logger = Logger();
  static final _backend = TripsBackend();
  static final _vistingPlaces = VisitingPlaceBackend();

  bool _dataIsInvalidated = false;

  TripsCubit() : super(TripsInitial([]));

  Future<void> invalidateTrips() async {
    _dataIsInvalidated = true;

    if (state is TripsLoading) {
      // If already fetching data, mark it invalid & exit
      _logger
          .i('Trips are already being fetched. Marking data as invalidated.');
      return;
    }

    // Set state as loading
    emit(TripsLoading(state.trips));

    // // Fetch data. If it was invalidated during the fetch, load it again.
    while (_dataIsInvalidated) {
      _dataIsInvalidated = false;
      var fetchedData = await _fetchTrips();
      if (!_dataIsInvalidated) {
        emit(TripsLoaded(fetchedData));
        _logger.i('Trips were fetched.');
        return;
      }
      _logger.i('Data was invalidated during fetch. Fetching again.');
    }
  }

  Future<List<(TripModel, List<VisitingPlaceModel>)>> _fetchTrips() async {
    List<(TripModel, List<VisitingPlaceModel>)> fetchedData = [];

    // Fetch trips from the backend
    var trips = await _backend.getTrips();
    state.trips.clear();

    // TODO: Indexing might be off. Sort them.
    var futures = <Future>[];
    for (var trip in trips) {
      futures.add(_vistingPlaces
          .getVisitingPlaces(trip.id)
          .then((places) => fetchedData.add((trip, places))));
    }
    await Future.wait(futures);

    return fetchedData;
  }

  Future<void> createTrip(String title) async {
    emit(TripsLoading(state.trips));

    // Create a new trip
    final newTrip =
        TripModel(id: Uuid().v7(), title: title, arriveAt: null, places: []);

    await _backend.saveTrip(newTrip);
    state.trips.add((newTrip, []));

    // Fetch the updated list of trips
    await invalidateTrips();
  }
}
