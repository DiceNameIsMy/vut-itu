import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  static final DatabaseHelper _db = DatabaseHelper();

  TripCubit(TripModel trip, List<TripCityModel> visitingPlaces)
      : super(TripInitial(trip, visitingPlaces));

  factory TripCubit.fromContext(BuildContext context, int tripId) {
    var trips = BlocProvider.of<TripsCubit>(context).state.trips;
    var result = trips.where((element) => element.$1.id == tripId).firstOrNull;
    if (result == null) {
      throw Exception('Trip with id $tripId not found in TripCubit');
    }

    var (trip, places) = result;
    return TripCubit(trip, places);
  }

  Future<void> invalidateVisitingPlaces() async {
    emit(TripLoading(state.trip, state.places));

    var visitingPlaces = await _db.getTripCitiesWithAll(tripId: state.trip.id);
    logger
        .i('Loaded ${visitingPlaces.length} places for trip ${state.trip.id}');

    emit(TripLoaded(state.trip, visitingPlaces));
  }

  Future<void> setStartDate(DateTime newStartDate) async {
    await _db.updateTrip(
      state.trip.id,
      {'start_date': newStartDate.toIso8601String()},
    );

    await invalidateTrip();
  }

  Future<void> setEndDate(DateTime newEndDate) async {
    await _db
        .updateTrip(state.trip.id, {'end_date': newEndDate.toIso8601String()});

    await invalidateTrip();
  }

  Future<void> setTripName(String newName) async {
    await _db.updateTrip(state.trip.id, {'name': newName});

    await invalidateTrip();
  }

  Future<void> invalidateTrip() async {
    var trip = TripModel.fromMap(await _db.getTrip(state.trip.id));
    var visitingPlaces = await _db.getTripCitiesWithAll(tripId: state.trip.id);

    emit(TripLoaded(trip, visitingPlaces));
  }

  /// Returns whether the city was already in the list of visiting places and is being added again
  Future<bool> addCityToVisitFromLocation(Location location) async {
    // If city does not exist in the DB, add it
    var city = await _db.getCityByGeoapifyId(location.geoapifyId);
    if (city == null) {
      city = CityModel.fromLocation(location);
      await _db.insertCity(city);
    }

    return await addCityToVisit(city);
  }

  /// Returns whether the city was already in the list of visiting places and is being added again
  Future<bool> addCityToVisit(CityModel city) async {
    var vistingAgain = state.places.any((element) => element.cityId == city.id);

    var cityToVisit = TripCityModel(
      tripId: state.trip.id,
      cityId: city.id,
      order: state.places.length,
    );
    await _db.insertSingleTripCity(cityToVisit);

    await invalidateVisitingPlaces();

    return vistingAgain;
  }

  void reoderPlaces(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (state.places.length < oldIndex || state.places.length < newIndex) {
      logger.e('Invalid indexes for reordering: $oldIndex, $newIndex');
      return;
    }

    final newPlaces = state.places.toList();

    final item = newPlaces.removeAt(oldIndex);
    newPlaces.insert(newIndex, item);

    // TODO: Emit a specific event so that everything is not rebuilt each time
    emit(TripLoaded(state.trip, newPlaces));

    // TODO: Update order in the database
  }

  Future<void> removeCity(int visitingPlaceIdx) async {
    // Remove from the list
    final newPlaces = state.places.toList();
    final item = newPlaces.removeAt(visitingPlaceIdx);

    emit(TripLoaded(state.trip, newPlaces));

    // Delete from the database
    await _db.deleteTripCity(item.id);

    // Refresh the list, just in case
    await invalidateVisitingPlaces();
  }
}
