import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/location.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(
    TripModel trip,
    List<Location> markers,
    LatLng centerAt,
    double zoomLevel,
  ) : super(
          MapInitial(
            trip: trip,
            markers: markers,
            centerAt: centerAt,
            zoomLevel: zoomLevel,
          ),
        );

  void openMarkerDetails() {
    emit(
      MapMarkerDetailsOpened(
        trip: state.trip,
        centerAt: state.centerAt,
        markers: state.markers,
        zoomLevel: state.zoomLevel,
      ),
    );
  }
}
