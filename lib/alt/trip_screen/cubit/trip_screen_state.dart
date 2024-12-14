part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {
  final List<Location> locations;

  TripScreenState({this.locations = const []});
}

final class TripScreenInitial extends TripScreenState {
  TripScreenInitial({super.locations = const []});
}

final class TripScreenLocationPressed extends TripScreenState {
  final Location selectedLocation;

  TripScreenLocationPressed({
    required this.selectedLocation,
    super.locations = const [],
  });
}

final class TripScreenShowLocations extends TripScreenState {
  TripScreenShowLocations({super.locations = const []});
}
