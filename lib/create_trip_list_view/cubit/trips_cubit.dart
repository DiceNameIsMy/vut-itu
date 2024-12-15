/*cubit to fetch all the trips of current user (current user always user 1) */
import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

class TripsCubit extends Cubit<List<TripModel>> {
  TripsCubit() : super([]);

  List<TripModel> _trips = [];

  Future<void> invalidateTrips() async {
    final tripMaps = await DatabaseHelper().getTrips();
    _trips = tripMaps.map((map) => TripModel.fromMap(map)).toList();
    emit(_trips);
  }

  void addTrip(TripModel trip) {
    _trips.add(trip);
    emit(_trips);
  }

  void removeTrip(TripModel trip) async {
    //remove all the cities of the trip from the database
    for (var city in trip.cities) {
      await DatabaseHelper().deleteAllTripAttractions(city.id!);
      await DatabaseHelper().deleteTripCity(city.id!);
    }
    await DatabaseHelper().deleteTrip(trip.id); // Ensure `deleteTrip` works
    _trips.removeWhere((t) => t.id == trip.id);
    emit(List.from(_trips)); // Emit a new instance of the list
  }

  void updateTrip(TripModel trip) {
    final index = _trips.indexWhere((t) => t.id == trip.id);
    _trips[index] = trip;
    emit(_trips);
  }
}
