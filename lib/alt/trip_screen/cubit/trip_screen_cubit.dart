import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  TripScreenCubit() : super(TripScreenInitial());

  factory TripScreenCubit.fromContext(BuildContext context) {
    return TripScreenCubit();
  }

  void showQueryResults(List<Location> queryResults) {
    logger.i('Showing ${queryResults.length} locations');
    emit(TripScreenShowLocations(locations: queryResults));
  }

  void selectLocation(Location location) {
    logger.i('Selected location: ${location.name}');
    emit(
      TripScreenShowLocations(
        locations: [location],
      ),
    );
  }
}
