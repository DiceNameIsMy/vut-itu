import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  final DatabaseHelper _db = DatabaseHelper();

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
            queryResults.map((l) => l.latLng).toList(),
          ),
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

  Future<void> selectLocation(Location location) async {
    logger.i('Selected location: ${location.name}');

    state.mapController.move(location.latLng, 10);

    emit(
      TripLoadAttractions(
        mapController: state.mapController,
        location: location,
      ),
    );

    var alreadyAdded = tripCubit.state.places
        .where((p) => p.city?.geoapifyId == location.geoapifyId)
        .isNotEmpty;
    if (alreadyAdded) {
      logger.i('City already exists in trip');
      return;
    }

    var tripCity = await tripCubit.addCityToVisit(location);

    // TODO: Load attractions from api of something.
    final attractions = (await _db.getAttractions(tripCity.cityId))
        .map((a) => AttractionModel.fromMap(a))
        .toList();

    emit(
      TripScreenShowLocationAttractions(
        location: location,
        attractions: attractions,
        mapController: state.mapController,
      ),
    );
    logger.i(
      'Loaded ${attractions.length} attractions for location: ${location.name}',
    );
  }

  Future<void> addLocation(Location location) async {
    var allAttractions = await _db.getAllAttractions();
    allAttractions.map((e) => AttractionModel.fromMap(e)).forEach((a) {
      logger.d('Attraction: ${a.name}, ${a.cityId}');
    });

    logger
        .i('Adding location: ${location.name} with id: ${location.geoapifyId}');

    await selectLocation(location);
  }
}
