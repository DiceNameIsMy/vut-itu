/* cubit that handles creation, update and removing tripCity from a selected trip and database table city.
All changes in the trip_city_model will be updated in the database */

import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'trip_city_cubit.dart';

class TripCityCubit extends Cubit<List<TripCityModel>> {
  TripCityCubit() : super([]);

  List<TripCityModel> _tripCities = [];

  Future<void> fetchTripCities(int tripId) async {
    final tripCityMaps = await DatabaseHelper().getTripCities(tripId: tripId);
    _tripCities =
        tripCityMaps.map((map) => TripCityModel.fromMap(map)).toList();
    emit(_tripCities);
  }

  void addCityToTrip(TripCityModel tripCity) {
    _tripCities.add(tripCity);
    emit(_tripCities);
  }

  void removeCityFromTrip(TripCityModel tripCity) {
    _tripCities.remove(tripCity);
    emit(_tripCities);
  }

  void updateCityInTrip(TripCityModel tripCity) {
    final index = _tripCities.indexWhere((tc) => tc.cityId == tripCity.cityId);
    _tripCities[index] = tripCity;
    emit(_tripCities);
  }

  Future<String> getCityName(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    return cityMap['name'];
  }
}
