part of 'map_cubit.dart';

@immutable
sealed class MapState {
  final LatLng? deviceLocation;

  MapState({
    this.deviceLocation,
  });

  MapState copyWith({
    LatLng? deviceLocation,
  });
}

final class MapInitial extends MapState {
  MapInitial({
    super.deviceLocation,
  });

  @override
  MapState copyWith({
    LatLng? deviceLocation,
  }) {
    return MapInitial(
      deviceLocation: deviceLocation ?? this.deviceLocation,
    );
  }
}

final class MapMarkerDetailsOpened extends MapState {
  MapMarkerDetailsOpened({
    super.deviceLocation,
  });

  @override
  MapState copyWith({
    LatLng? deviceLocation,
  }) {
    return MapMarkerDetailsOpened(
      deviceLocation: deviceLocation ?? this.deviceLocation,
    );
  }
}
