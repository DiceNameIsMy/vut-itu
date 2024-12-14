part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {
  final MapController mapController;

  final List<Location> locations;

  TripScreenState({required this.mapController, this.locations = const []});
}

final class TripScreenInitial extends TripScreenState {
  TripScreenInitial({required super.mapController, super.locations = const []});
}

final class TripScreenLocationSelected extends TripScreenState {
  final Location selectedLocation;

  TripScreenLocationSelected({
    required super.mapController,
    required this.selectedLocation,
    super.locations = const [],
  });
}

final class TripScreenShowLocations extends TripScreenState {
  TripScreenShowLocations(
      {required super.mapController, super.locations = const []});
}
