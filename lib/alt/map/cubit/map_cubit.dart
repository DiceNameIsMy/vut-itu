import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(TripModel trip, VisitingPlaceModel selectedPlace, LatLng centerAt,
      double zoomLevel)
      : super(MapInitial(
            trip: trip,
            centerAt: centerAt,
            zoomLevel: zoomLevel,
            selectedPlace: selectedPlace));

  void openMarkerDetails(MapState oldState) {
    emit(MapMarkerDetailsOpened(
        trip: oldState.trip,
        selectedPlace: oldState.selectedPlace,
        centerAt: state.centerAt,
        zoomLevel: state.zoomLevel));
  }
}
