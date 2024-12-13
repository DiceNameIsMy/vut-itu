import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'trip_city_cubit.dart';

class TripCubit extends Cubit<TripModel> {
  TripCubit() : super(TripModel());

  TripModel _trip = TripModel();

  void resetTrip() {
    _trip = TripModel();
    emit(_trip);
    emit(_trip.copyWith(cities: []));
  }

  //fetch trip with cities from the database
  Future<void> fetchTrip(int id) async {
    final trip = await DatabaseHelper().getTrip(id);
    _trip = TripModel.fromMap(trip);
    final tripCities = await DatabaseHelper().getTripCities(tripId: id);
    _trip.cities = tripCities
        .map((e) => TripCityModel.fromMap(e))
        .toList()
        .cast<TripCityModel>();
    emit(_trip);
  }
  //TODO refactor update methods to use the emit method instead of the _trip variable

  //update the trip with the new name
  Future<void> updateTripName(String name) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'name': name});
    emit(_trip.copyWith(name: name));
  }

  //update the trip with the new budget
  Future<void> updateTripBudget(double budget) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'budget': budget});
    emit(_trip.copyWith(budget: budget));
  }

  //update the trip with the new start date
  Future<void> updateTripStartDate(DateTime startDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'start_date': startDate.toIso8601String()});
    emit(state.copyWith(startDate: startDate));
  }

  //update the trip with the new end date
  Future<void> updateTripEndDate(DateTime endDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'end_date': endDate.toIso8601String()});
    emit(state.copyWith(endDate: endDate));
  }

  //add a city to the trip in the correct order
  Future<void> addCityToTrip(CityModel city) async {
    final tripCity = TripCityModel(
      cityId: city.id!,
      tripId: _trip.id!,
      order: _trip.cities.length + 1,
    );

    // Insert the trip city into the database
    final insertedTripCity =
        await DatabaseHelper().insertSingleTripCity(tripCity);

    // Update local _trip.cities list
    _trip.cities.add(insertedTripCity);

    // Emit the updated state
    emit(
        _trip.copyWith(cities: List.from(_trip.cities))); // Ensure immutability
  }

  //TODO REMOVE ALL ATTRACTIONS FROM CITY
  //remove a city from the trip
  Future<void> removeCityFromTrip(TripCityModel tripCity) async {
    await DatabaseHelper().deleteTripCity(tripCity.cityId);
    _trip.cities.remove(tripCity);
    emit(_trip.copyWith(cities: _trip.cities));
  }

  //get city name from the city id
  Future<String> getCityName(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    final city = CityModel.fromMap(cityMap);
    return city.name;
  }

  //insert the trip to the database
  Future<void> saveTrip() async {
    await DatabaseHelper().insertTrip(_trip);
    emit(_trip);
  }

  //save the trip to the database
  Future<void> updateTrip() async {
    await DatabaseHelper().updateTrip(_trip.id!, _trip.toMap());
  }
}
