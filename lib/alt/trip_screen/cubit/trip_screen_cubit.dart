import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  final TripCubit tripCubit;

  TripScreenCubit(this.tripCubit)
      : super(TripScreenInitial(mapController: MapController()));

  factory TripScreenCubit.fromContext(BuildContext context) {
    return TripScreenCubit(BlocProvider.of<TripCubit>(context));
  }

  void showQueryResults(List<Location> queryResults) {
    logger.i('Showing ${queryResults.length} locations');

    if (queryResults.isNotEmpty) {
      state.mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(
              queryResults.map((l) => l.latLng).toList()),
          padding: EdgeInsets.all(100),
        ),
      );
    }

    emit(
      TripScreenShowLocations(
        mapController: state.mapController,
        locations: queryResults,
      ),
    );
  }

  void selectLocation(Location location) {
    logger.i('Selected location: ${location.name}');

    state.mapController.move(location.latLng, 10);

    emit(
      TripScreenShowLocations(
        mapController: state.mapController,
        locations: [location],
      ),
    );
  }

  Future<void> addLocation(Location location) async {
    logger.i('Added location: ${location.name}');

    state.mapController.move(location.latLng, 10);

    emit(
      TripScreenShowLocations(
        mapController: state.mapController,
        locations: [location],
      ),
    );

    await tripCubit.addCityToVisit(location);
  }
}
