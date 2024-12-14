import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/geolocation.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(
    MapController mapController,
    TripModel trip,
    List<Location> markers,
  ) : super(
          MapInitial(
            mapController: mapController,
            trip: trip,
            markers: markers,
          ),
        );

  Future<void> invalidateDeviceLocation() async {
    await Geolocation.determinePosition().then((position) {
      logger.d('Device location: ${position.latitude}, ${position.longitude}');

      logger.d(
          'Fitting camera to ${state.markers.map((m) => m.latLng).toList()..add(LatLng(position.latitude, position.longitude))}');

      // TODO: Add marker of user's location

      emit(
        state.copyWith(
          deviceLocation: LatLng(position.latitude, position.longitude),
        ),
      );
    });
  }

  void openMarkerDetails() {
    emit(
      MapMarkerDetailsOpened(
        deviceLocation: state.deviceLocation,
        mapController: state.mapController,
        trip: state.trip,
        markers: state.markers,
      ),
    );
  }
}
