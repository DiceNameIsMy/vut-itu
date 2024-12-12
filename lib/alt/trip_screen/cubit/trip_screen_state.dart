part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {}

final class TripScreenInitial extends TripScreenState {}

final class TripScreenSelectedMarker extends TripScreenState {}
