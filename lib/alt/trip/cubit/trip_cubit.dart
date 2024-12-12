import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
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
}
