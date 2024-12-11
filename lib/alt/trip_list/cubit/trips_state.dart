part of 'trips_cubit.dart';

@immutable
sealed class TripsState {
  final List<(TripModel, List<TripCityModel>)> trips;
  final bool loading;

  TripsState(this.trips, {this.loading = false});
}

final class TripsInitial extends TripsState {
  TripsInitial(super.trips) : super(loading: false);
}

final class TripsLoading extends TripsState {
  TripsLoading(super.trips) : super(loading: true);
}

final class TripsLoaded extends TripsState {
  TripsLoaded(super.trips) : super(loading: false);
}
