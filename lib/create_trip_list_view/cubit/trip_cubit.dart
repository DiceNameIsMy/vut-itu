import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'trip_city_cubit.dart';

class TripCubit extends Cubit<TripModel> {
  TripCubit() : super(TripModel());

  TripModel _trip = TripModel();

  //fetch the trip from the database
  void fetchTrip(int id) async {
    final trip = await DatabaseHelper().getTrip(id);
    _trip = TripModel.fromMap(trip);
    emit(_trip);
  }
  //TODO refactor update methods to use the emit method instead of the _trip variable

  //update the trip with the new name
  void updateTripName(String name) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'name': name});
    emit(_trip.copyWith(name: name));
  }

  //update the trip with the new budget
  void updateTripBudget(double budget) async {
    await DatabaseHelper().updateTrip(_trip.id!, {'budget': budget});
    emit(_trip.copyWith(budget: budget));
  }

  //update the trip with the new start date
  void updateTripStartDate(DateTime startDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'startDate': startDate.toIso8601String()});
    emit(_trip.copyWith(startDate: startDate));
  }

  //update the trip with the new end date
  void updateTripEndDate(DateTime endDate) async {
    await DatabaseHelper()
        .updateTrip(_trip.id!, {'endDate': endDate.toIso8601String()});
    emit(_trip.copyWith(endDate: endDate));
  }

  //add a city to the trip in the correct order
  void addCityToTrip(CityModel city) async {
    final tripCity = TripCityModel(
        cityId: city.id!, tripId: _trip.id!, order: _trip.cities.length + 1);
    await DatabaseHelper().insertTripCity(tripCity.cityId, _trip.cities);
    _trip.cities.add(tripCity);
    emit(_trip.copyWith(cities: _trip.cities));
  }

  //remove a city from the trip
  void removeCityFromTrip(TripCityModel tripCity) async {
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
  }

  //save the trip to the database
  Future<void> updateTrip() async {
    await DatabaseHelper().updateTrip(_trip.id!, _trip.toMap());
  }
}
