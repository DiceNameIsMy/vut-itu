part of 'device_location_cubit.dart';

@immutable
sealed class DeviceLocationState {
  DeviceLocationState();
}

final class DeviceLocationInitial extends DeviceLocationState {
  DeviceLocationInitial();
}

final class DeviceLocationLoaded extends DeviceLocationState {
  final LatLng deviceLocation;

  DeviceLocationLoaded({required this.deviceLocation});
}
