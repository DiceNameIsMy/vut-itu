part of 'trip_cubit.dart';

@immutable
sealed class TripState {
  final TripModel trip;
  final List<TripCityModel> places;

  TripState(this.trip, this.places);
}

final class TripInitial extends TripState {
  TripInitial(super.trip, super.places);
}
