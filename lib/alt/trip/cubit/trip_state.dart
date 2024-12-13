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

final class TripLoading extends TripState {
  TripLoading(super.trip, super.places);
}

final class TripLoaded extends TripState {
  TripLoaded(super.trip, super.places);
}
