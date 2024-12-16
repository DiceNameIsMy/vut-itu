import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/logger.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  static final DatabaseHelper _db = DatabaseHelper();

  bool _dataIsInvalidated = false;

  TripsCubit() : super(TripsInitial([]));

  Future<void> invalidateTrips() async {
    _dataIsInvalidated = true;

    if (state is TripsLoading) {
      // If already fetching data, mark it invalid & exit
      logger.i('Trips are already being fetched. Marking data as invalidated');
      return;
    }

    // Set state as loading
    logger.i('Invalidating trips');
    emit(TripsLoading(state.trips));

    // // Fetch data. If it was invalidated during the fetch, load it again.
    while (_dataIsInvalidated) {
      _dataIsInvalidated = false;
      var fetchedData = await _fetchTrips();
      if (!_dataIsInvalidated) {
        emit(TripsLoaded(fetchedData));
        logger.i('Trips were fetched.');
        return;
      }
      logger.i('Data was invalidated during fetch. Fetching again');
    }
  }

  Future<List<(TripModel, List<TripCityModel>)>> _fetchTrips() async {
    var fetchedData =
        List<(TripModel, List<TripCityModel>)>.empty(growable: true);

    // Fetch trips from the backend
    var trips =
        (await _db.getTrips(orderByField: 'start_date', orderByAsc: true))
            .map(TripModel.fromMap)
            .toList();

    // Fetch the cities for each trip & pair them together
    var futures = <Future>[];
    for (var trip in trips) {
      futures.add(
        _db.getTripCities(tripId: trip.id).then((tripCitiesMap) {
          var tripCities = tripCitiesMap.map(TripCityModel.fromMap).toList();
          fetchedData.add((trip, tripCities));
        }),
      );
    }
    await Future.wait(futures);

    return fetchedData;
  }

  Future<void> createTrip(String name) async {
    emit(TripsLoading(state.trips));

    // Create a new trip
    final newTrip = TripModel(userId: 1, name: name, startDate: null);
    await _db.insertTrip(newTrip);

    state.trips.add((newTrip, []));

    // Fetch the updated list of trips
    await invalidateTrips();
  }

  Future<void> updateTripName(int tripId, String newName) async {
    emit(TripsLoading(state.trips));

    // Update the trip
    await _db.updateTrip(tripId, {'name': newName});

    // Fetch the updated list of trips
    await invalidateTrips();
  }
}
