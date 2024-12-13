part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {
  final List<String> searchSuggestions;

  TripScreenState({this.searchSuggestions = const []});
}

final class TripScreenInitial extends TripScreenState {
  TripScreenInitial({super.searchSuggestions = const []});
}

final class TripScreenSelectedMarker extends TripScreenState {
  TripScreenSelectedMarker({super.searchSuggestions = const []});
}
