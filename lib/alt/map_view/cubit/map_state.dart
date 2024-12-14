part of 'map_cubit.dart';

@immutable
sealed class MapState {
  final LatLng? deviceLocation;
  final MapController mapController;

  final TripModel trip;

  final List<Location> markers;

  MapState({
    this.deviceLocation,
    required this.mapController,
    required this.trip,
    required this.markers,
  });

  MapState copyWith({
    LatLng? deviceLocation,
    MapController? mapController,
    TripModel? trip,
    List<Location>? markers,
  });
}

final class MapInitial extends MapState {
  MapInitial({
    super.deviceLocation,
    required super.mapController,
    required super.trip,
    required super.markers,
  });

  @override
  MapState copyWith(
      {LatLng? deviceLocation,
      MapController? mapController,
      TripModel? trip,
      List<Location>? markers}) {
    return MapInitial(
      deviceLocation: deviceLocation ?? this.deviceLocation,
      mapController: mapController ?? this.mapController,
      trip: trip ?? this.trip,
      markers: markers ?? this.markers,
    );
  }
}

final class MapMarkerDetailsOpened extends MapState {
  MapMarkerDetailsOpened({
    super.deviceLocation,
    required super.mapController,
    required super.trip,
    required super.markers,
  });

  @override
  MapState copyWith(
      {LatLng? deviceLocation,
      MapController? mapController,
      TripModel? trip,
      List<Location>? markers}) {
    return MapMarkerDetailsOpened(
      deviceLocation: deviceLocation ?? this.deviceLocation,
      mapController: mapController ?? this.mapController,
      trip: trip ?? this.trip,
      markers: markers ?? this.markers,
    );
  }
}
