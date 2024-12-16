import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/backend/geolocation.dart';
import 'package:vut_itu/logger.dart';

part 'device_location_state.dart';

class DeviceLocationCubit extends Cubit<DeviceLocationState> {
  DeviceLocationCubit() : super(DeviceLocationInitial());

  Future<LatLng?> invalidateDeviceLocation() async {
    Position position;
    try {
      position = await Geolocation.determinePosition();
    } catch (e) {
      logger.e('Failed to determine device location: $e');
      return null;
    }

    if (isClosed) {
      // TODO: Can happen in many places. Better to ensure every place is safely handles.
      return null;
    }

    logger.d('Device location: ${position.latitude}, ${position.longitude}');
    var deviceLocation = LatLng(position.latitude, position.longitude);
    emit(DeviceLocationLoaded(deviceLocation: deviceLocation));
    return deviceLocation;
  }
}
