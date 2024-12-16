import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/trip_screen/cubit/trip_screen_cubit.dart';
import 'package:vut_itu/backend/geolocation.dart';
import 'package:vut_itu/logger.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final TripScreenCubit tripScreenCubit;

  MapCubit(this.tripScreenCubit) : super(MapInitial());

  factory MapCubit.fromContext(BuildContext context) {
    return MapCubit(BlocProvider.of<TripScreenCubit>(context));
  }

  Future<void> invalidateDeviceLocation() async {
    Position position;
    try {
      position = await Geolocation.determinePosition();
    } catch (e) {
      logger.e('Failed to determine device location: $e');
      return;
    }
    logger.d('Device location: ${position.latitude}, ${position.longitude}');

    var markers = tripScreenCubit.state.locations.map((m) => m.latLng).toList()
      ..add(LatLng(position.latitude, position.longitude));

    logger.d('Fitting camera to $markers');

    if (isClosed) {
      // TODO: Can happen in many places. Better to ensure every place is safely handles.
      return;
    }

    emit(
      state.copyWith(
        deviceLocation: LatLng(position.latitude, position.longitude),
      ),
    );
  }

  void openMarkerDetails() {
    emit(MapMarkerDetailsOpened(deviceLocation: state.deviceLocation));
  }
}
