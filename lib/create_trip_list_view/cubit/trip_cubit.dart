import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'trip_city_cubit.dart';

/*
 * Cubit for creation a new trip in the database with a list of selected cities from the search bar .
 *  Updating the trip name, budget, start date and end date .
 * Adding and removing cities from the trip using the TripCityCubit.
 * All changes in the trip_model will be updated in the database.
 */

class TripCubit extends Cubit<TripModel> {
  TripCubit() : super(TripModel());

  TripModel _trip = TripModel();

  Future<void> fetchTrip(int tripId) async {
    final tripMap = await DatabaseHelper().getTrip(tripId);
    _trip = TripModel.fromMap(tripMap);
    emit(_trip);
  }

  void updateTripName(String name) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'name': name});
    _trip.name = name;
    emit(_trip);
  }

  void updateTripBudget(double budget) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'budget': budget});
    _trip.budget = budget;
    emit(_trip);
  }

  void updateTripStartDate(DateTime startDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'start_date': startDate.toIso8601String()});
    _trip.startDate = startDate;
    emit(_trip);
  }

  void updateTripEndDate(DateTime endDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'end_date': endDate.toIso8601String()});
    _trip.endDate = endDate;
    emit(_trip);
  }

  void addCityToTrip(CityModel city) async {
    final tripCity = TripCityModel(
      tripId: _trip.id!,
      cityId: city.id!,
      order: _trip.cities.length + 1,
    );
    _trip.cities.add(tripCity);
    await DatabaseHelper().insertTripCity(_trip.id!, [tripCity]);
    emit(_trip);
  }

  void removeCityFromTrip(int cityId) async {
    await DatabaseHelper().deleteTripCity(cityId);
    _trip.cities.removeWhere((tc) => tc.cityId == cityId);
    emit(_trip);
  }

  void updateCityInTrip(TripCityModel tripCity) async {
    final index = _trip.cities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _trip.cities[index] = tripCity;
    await DatabaseHelper().updateTripCity(_trip.id!, tripCity.toMap());
    emit(_trip);
  }

  Future<String> getCityName(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    return cityMap['name'];
  }

  Future<void> saveTrip() async {
    if (_trip.id == null) {
      _trip.id = await DatabaseHelper().insertTrip(_trip);
    } else {
      await DatabaseHelper().updateTrip(_trip.id!, _trip.toMap());
    }
    // for (final tripCity in _trip.cities) {
    //   if (tripCity.id == null) {
    //     await DatabaseHelper().insertTripCity(_trip.id!, [tripCity]);
    //   } else {
    //     await DatabaseHelper().updateTripCity(_trip.id!, tripCity.toMap());
    //   }
    // }
  }

  //remove the trip from the database and all associated cities
  Future<void> deleteTrip() async {
    //delete all associated cities
    for (final tripCity in _trip.cities) {
      await DatabaseHelper().deleteTripCity(tripCity.id!);
    }
    await DatabaseHelper().deleteTrip(_trip.id!);
    _trip = TripModel();
    emit(_trip);
  }
}
