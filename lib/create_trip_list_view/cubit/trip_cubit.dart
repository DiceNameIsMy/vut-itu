import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';

class TripCubit extends Cubit<TripModel> {
  TripCubit() : super(TripModel());

  // Reset the trip state
  void resetTrip() {
    emit(TripModel()); // Reset state to default
  }

  // Fetch trip from database and update state
  Future<void> fetchTrip(int id) async {
    final trip = await DatabaseHelper().getTrip(id);
    final tripCities = await DatabaseHelper().getTripCities(tripId: id);

    final tripModel = TripModel.fromMap(trip);

    List<TripCityModel> citiesList =
        tripCities.map((e) => TripCityModel.fromMap(e)).toList();

    citiesList.sort((a, b) => a.order.compareTo(b.order));

    tripModel.cities = citiesList;
    emit(tripModel);
  }

  // Update the trip name in the database and state
  Future<void> updateTripName(String name) async {
    final updatedTrip = state.copyWith(name: name);
    await DatabaseHelper().updateTrip(state.id, {'name': name});
    emit(updatedTrip); // Emit the updated state
  }

  // Update the trip budget in the database and state
  Future<void> updateTripBudget(double budget) async {
    final updatedTrip = state.copyWith(budget: budget);
    await DatabaseHelper().updateTrip(state.id, {'budget': budget});
    emit(updatedTrip); // Emit the updated state
  }

  // Update the trip start date in the database and state
  Future<void> updateTripStartDate(DateTime startDate) async {
    final updatedTrip = state.copyWith(startDate: startDate);
    await DatabaseHelper()
        .updateTrip(state.id, {'start_date': startDate.toIso8601String()});
    emit(updatedTrip); // Emit the updated state
  }

  // Update the trip end date in the database and state
  Future<void> updateTripEndDate(DateTime endDate) async {
    final updatedTrip = state.copyWith(endDate: endDate);
    await DatabaseHelper()
        .updateTrip(state.id, {'end_date': endDate.toIso8601String()});
    emit(updatedTrip); // Emit the updated state
  }

  // Add a city to the trip in the database and state
  Future<void> addCityToTrip(CityModel city) async {
    final tripCity = TripCityModel(
      cityId: city.id,
      tripId: state.id,
      order: state.cities.length + 1,
    );

    final insertedTripCity =
        await DatabaseHelper().insertSingleTripCity(tripCity);
    final updatedCities = List<TripCityModel>.from(state.cities)
      ..add(insertedTripCity);
    final updatedTrip = state.copyWith(cities: updatedCities);

    emit(updatedTrip); // Emit the updated state
  }

  // Remove a city from the trip in the database and state
  Future<void> removeCityFromTrip(TripCityModel tripCity) async {
    await DatabaseHelper().deleteTripCity(tripCity.id);
    await DatabaseHelper().deleteAllTripAttractions(tripCity.id);

    final updatedCities = List<TripCityModel>.from(state.cities)
      ..remove(tripCity);
    final updatedTrip = state.copyWith(cities: updatedCities);
    emit(updatedTrip); // Emit the updated state
  }

  // Get city name by its ID
  Future<String> getCityName(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    final city = CityModel.fromMap(cityMap);
    return city.name;
  }

  // Get city country by its ID
  Future<String> getCityCountry(int cityId) async {
    final cityMap = await DatabaseHelper().getCity(cityId);
    final city = CityModel.fromMap(cityMap);
    return city.country;
  }

  // Save the trip to the database
  Future<void> saveTrip() async {
    await DatabaseHelper().insertTrip(state); // Save the current state
    emit(state); // Emit the current state
  }

  // Update the trip in the database
  Future<void> updateTrip() async {
    await DatabaseHelper().updateTrip(state.id, state.toMap());
    emit(state); // Emit the current state
  }

  // Reorder the cities in the state and update the database
  Future<void> reorderCities(int oldIndex, int newIndex) async {
    // Adjust for the case where the newIndex is after the oldIndex
    if (newIndex > oldIndex) newIndex -= 1;

    // Create a copy of the cities list and move the city
    final updatedCities = List.of(state.cities);
    final movedCity = updatedCities.removeAt(oldIndex);
    updatedCities.insert(newIndex, movedCity);

    // Update the order of the cities in the database
    for (int i = 0; i < updatedCities.length; i++) {
      final city = updatedCities[i];
      city.order = i + 1; // Update order starting from 1
      await updateTripCityOrder(city.id, city.order);
    }

    // Emit the updated state with the reordered cities
    emit(state.copyWith(cities: updatedCities));
  }

// Update the order of a city in the database
  Future<void> updateTripCityOrder(int cityId, int order) async {
    await DatabaseHelper().updateTripCity(cityId, {'order_in_list': order});
  }
}
