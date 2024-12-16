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

final class TripScreenShowLocations extends TripScreenState {
  TripScreenShowLocations({
    required super.mapController,
    super.locations = const [],
  });
}

final class TripLoadAttractions extends TripScreenState {
  final Location location;

  TripLoadAttractions({
    required this.location,
    required super.mapController,
    super.locations = const [],
  });
}

final class TripScreenShowLocationAttractions extends TripScreenState {
  final Location location;
  final List<AttractionModel> attractions;

  TripScreenShowLocationAttractions({
    required this.location,
    required this.attractions,
    required super.mapController,
    super.locations = const [],
  });
}
