/* cubit that handles creation, update and removing tripCity from a selected trip and database table city.
All changes in the trip_city_model will be updated in the database */

import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'trip_attraction_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';

class TripCityCubit extends Cubit<List<TripCityModel>> {
  TripCityCubit() : super([]);

  List<TripCityModel> _tripCities = [];

  Future<void> fetchTripCities(int tripId) async {
    final tripCityMaps = await DatabaseHelper().getTripCities(tripId: tripId);
    _tripCities =
        tripCityMaps.map((map) => TripCityModel.fromMap(map)).toList();
    emit(_tripCities);
  }

  Future<void> updateCityInTrip(TripCityModel tripCity) async {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index] = tripCity;
    await DatabaseHelper().updateTripCity(tripCity.cityId, tripCity.toMap());
    emit(_tripCities);
  }

  Future<String> getCityName(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    return cityMap['name'];
  }

  //add attraction to the tripCity
  Future<void> addAttractionToTripCity(
      TripCityModel tripCity, TripAttractionModel tripAttraction) async {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index].attractions?.add(tripAttraction);
    await DatabaseHelper().insertTripAttraction(tripAttraction, tripCity);
    emit(_tripCities);
  }

  //remove attraction from the tripCity
  Future<void> removeAttractionFromTripCity(
      TripCityModel tripCity, TripAttractionModel tripAttraction) async {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index].attractions?.remove(tripAttraction);
    await DatabaseHelper().deleteTripAttraction(tripAttraction.id!);
    emit(_tripCities);
  }

  //culculate the total cost of the city from the attractions in the tripCity
  double calculateTotalCost(TripCityModel tripCity) {
    return tripCity.attractions?.fold(
            0,
            (previousValue, element) =>
                previousValue! + (element.expectedCost ?? 0)) ??
        0;
  }

  //culculate the total time of the city from the attractions in the tripCity
  double calculateTotalTime(TripCityModel tripCity) {
    return tripCity.attractions?.fold(
            0,
            (previousValue, element) =>
                previousValue! + (element.expectedTimeToVisitInHours ?? 0)) ??
        0;
  }

  //ubdate start date of the tripCity
  Future<void> updateStartDate(
      TripCityModel tripCity, DateTime startDate) async {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index].startDate = startDate;
    await DatabaseHelper().updateTripCity(
        tripCity.cityId, {'startDate': startDate.toIso8601String()});
    emit(_tripCities);
  }

  //ubdate end date of the tripCity
  Future<void> updateEndDate(TripCityModel tripCity, DateTime endDate) async {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index].endDate = endDate;
    await DatabaseHelper().updateTripCity(
        tripCity.cityId, {'endDate': endDate.toIso8601String()});
    emit(_tripCities);
  }
}
