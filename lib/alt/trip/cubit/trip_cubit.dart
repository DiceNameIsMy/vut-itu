import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
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
        state.trip.id, {'start_date': newStartDate.toIso8601String()});

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
}
