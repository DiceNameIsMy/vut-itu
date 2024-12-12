import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(TripModel trip, LatLng centerAt, double zoomLevel)
      : super(MapInitial(trip: trip, centerAt: centerAt, zoomLevel: zoomLevel));

  void openMarkerDetails(MapState oldState) {
    emit(MapMarkerDetailsOpened(
        trip: oldState.trip,
        centerAt: state.centerAt,
        zoomLevel: state.zoomLevel));
  }
}
