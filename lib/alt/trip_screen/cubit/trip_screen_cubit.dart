import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
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
      if (queryResults.length == 1) {
        state.mapController.move(queryResults[0].latLng, 10);
      } else {
        var boundingPoints =
            LatLngBounds.fromPoints(queryResults.map((l) => l.latLng).toList());

        logger.d('Fitting camera to $boundingPoints');
        state.mapController.fitCamera(
          CameraFit.bounds(
            bounds: boundingPoints,
            padding: EdgeInsets.all(100),
          ),
        );
      }
    }

    emit(
      TripScreenShowLocations(
        mapController: state.mapController,
        locations: queryResults,
      ),
    );
  }

  Future<CityModel> selectLocation(Location location) async {
    logger.i('Selected location: ${location.name}');

    // Load attractions for the location
    emit(
      TripLoadingAttractions(
        mapController: state.mapController,
        location: location,
      ),
    );

    // TODO: Load attractions from api of something.
    var city = await _db.getCityByGeoapifyId(location.geoapifyId);
    if (city == null) {
      city = CityModel(name: location.name, country: location.country);
      await _db.insertCity(city);
    }

    final attractions = (await _db.getAttractions(city.id))
        .map((a) => AttractionModel.fromMap(a))
        .toList();

    // Show attractions on the map
    emit(
      TripScreenShowLocationAttractions(
        location: location,
        attractions: attractions,
        mapController: state.mapController,
      ),
    );

    // Move focus to the selected location
    var coords = attractions.isEmpty
        ? [
            location.latLng,
            LatLng(location.latLng.latitude + 1, location.latLng.latitude + 1)
          ]
        : attractions.map((a) => a.coordinates).toList();
    logger.i('Fitting camera to $coords');

    state.mapController.move(location.latLng, 10);

    logger.i(
      'Loaded ${attractions.length} attractions for location: ${location.name}',
    );

    return city;
  }

  Future<bool> addLocation(Location location) async {
    logger
        .i('Adding location: ${location.name} with id: ${location.geoapifyId}');

    var tripCity = await selectLocation(location);

    var visitingAgain = await tripCubit.addCityToVisit(tripCity);
    return visitingAgain;
  }

  void focusOnLocation(LatLng deviceLocation, {double zoomLevel = 10}) {
    state.mapController.move(deviceLocation, zoomLevel);
  }
}
