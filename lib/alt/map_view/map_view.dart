import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/cubit/map_cubit.dart';
import 'package:vut_itu/alt/map_view/map_marker_detail_view.dart';
import 'package:vut_itu/alt/trip_screen/cubit/trip_screen_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final TripModel trip;
  final List<Location> locations;

  // Define how to query tiles that are used to show a map.
  final TileLayer tileProvider = TileLayer(
    urlTemplate:
        'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey=e3ea74d99880486cb73bc554b25dfe84',
    // Use the recommended flutter_map_cancellable_tile_provider package to
    // support the cancellation of loading tiles.
    tileProvider: CancellableNetworkTileProvider(),
  );

  MapView({
    super.key,
    required this.mapController,
    required this.trip,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripScreenCubit, TripScreenState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              MapCubit.fromContext(context)..invalidateDeviceLocation(),
          child: BlocBuilder<MapCubit, MapState>(
            builder: (context, _) {
              return _build(context, state);
            },
          ),
        );
      },
    );
  }

  Widget _build(BuildContext context, TripScreenState state) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FlutterMap(
          mapController: state.mapController,
          options: MapOptions(
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(-90, -180),
                const LatLng(90, 180),
              ),
            ),
            onTap: (tapPosition, point) {
              logger.d('Tapped on point: $point');
            },
          ),
          children: [tileProvider, _polylineLayer(), _markerLayer()],
        ),
        Positioned(
          right: 10,
          bottom: 100,
          child: FloatingActionButton.small(
            child: Icon(Icons.my_location),
            onPressed: () {
              context.read<MapCubit>().focusOnDeviceLocation();
            },
          ),
        ),
      ],
    );
  }

  PolylineLayer<Object> _polylineLayer() {
    logger.i('Building polyline');
    // TODO: Load polylines for navigation
    return PolylineLayer(polylines: []);
  }

  BlocBuilder<MapCubit, MapState> _markerLayer() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        logger.i('Building ${locations.length} markers');
        var markers = locations.map((m) => _marker(context, m)).toList();
        if (state.deviceLocation != null) {
          markers.add(_deviceLocationMarker(context, state.deviceLocation!));
        }
        return MarkerLayer(markers: markers);
      },
    );
  }

  Marker _marker(BuildContext context, Location marker) {
    return Marker(
      point: marker.latLng,
      width: 80,
      height: 80,
      child: IconButton(
        icon: Icon(Icons.location_city, color: Colors.purple),
        onPressed: () => {
          context.read<MapCubit>().openMarkerDetails(),
          showModalBottomSheet(
            context: context,
            // TODO: Proper modal content
            builder: (_) => MapMarkerDetailView(),
          ),
        },
      ),
    );
  }

  Marker _deviceLocationMarker(BuildContext context, LatLng location) {
    return Marker(
      point: location,
      width: 80,
      height: 80,
      child: IconButton(
        icon: Icon(Icons.location_pin, color: Colors.purple),
        onPressed: () => {
          context.read<MapCubit>().openMarkerDetails(),
          showModalBottomSheet(
            context: context,
            builder: (_) => MapMarkerDetailView(),
          ),
        },
      ),
    );
  }
}
