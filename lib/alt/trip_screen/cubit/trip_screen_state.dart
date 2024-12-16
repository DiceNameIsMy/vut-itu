part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {
  final MapController mapController;

  TripScreenState({required this.mapController});
}

final class TripScreenInitial extends TripScreenState {
  TripScreenInitial({required super.mapController});
}

final class TripScreenShowLocations extends TripScreenState {
  final List<Location> locations;

  TripScreenShowLocations({
    required super.mapController,
    this.locations = const [],
  });
}

final class TripLoadingAttractions extends TripScreenState {
  final Location location;

  TripLoadingAttractions({
    required this.location,
    required super.mapController,
  });
}

final class TripScreenShowLocationAttractions extends TripScreenState {
  final Location location;
  final List<AttractionModel> attractions;

  TripScreenShowLocationAttractions({
    required this.location,
    required this.attractions,
    required super.mapController,
  });
}
