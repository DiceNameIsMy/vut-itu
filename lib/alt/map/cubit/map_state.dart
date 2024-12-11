part of 'map_cubit.dart';

@immutable
sealed class MapState {
  final TripModel trip;
  final TripCityModel selectedPlace;
  final LatLng centerAt;
  final double zoomLevel;

  MapState(
      {required this.trip,
      required this.selectedPlace,
      required this.centerAt,
      required this.zoomLevel});
}

final class MapInitial extends MapState {
  MapInitial(
      {required super.trip,
      required super.centerAt,
      required super.zoomLevel,
      required super.selectedPlace});
}

final class MapMarkerDetailsOpened extends MapState {
  MapMarkerDetailsOpened(
      {required super.trip,
      required super.centerAt,
      required super.zoomLevel,
      required super.selectedPlace});
}
