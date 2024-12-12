part of 'map_cubit.dart';

@immutable
sealed class MapState {
  final TripModel trip;
  final LatLng centerAt;
  final double zoomLevel;

  MapState({
    required this.trip,
    required this.centerAt,
    required this.zoomLevel,
  });
}

final class MapInitial extends MapState {
  MapInitial({
    required super.trip,
    required super.centerAt,
    required super.zoomLevel,
  });
}

final class MapMarkerDetailsOpened extends MapState {
  MapMarkerDetailsOpened({
    required super.trip,
    required super.centerAt,
    required super.zoomLevel,
  });
}
