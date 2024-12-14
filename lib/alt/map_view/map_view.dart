import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/cubit/map_cubit.dart';
import 'package:vut_itu/alt/map_view/map_marker_detail_view.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

class MapView extends StatelessWidget {
  final TripModel trip;
  final List<Location> locations;
  final LatLng centerAt;
  final double initZoomLevel;

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
    required this.trip,
    required this.locations,
    required this.centerAt,
    required this.initZoomLevel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(trip, locations, centerAt, initZoomLevel),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: centerAt,
          initialZoom: initZoomLevel,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
          onTap: (tapPosition, point) {
            print('Tapped on point: $point');
          },
        ),
        children: [tileProvider, _polylineLayer(), _markerLayer()],
      ),
    );
  }

  PolylineLayer<Object> _polylineLayer() {
    logger.i('Building polyline');
    return PolylineLayer(polylines: [
      Polyline(
        color: Colors.red,
        strokeWidth: 4.0,
        points: [
          LatLng(48.8699, 2.3522),
          LatLng(48.86998, 2.352723),
          LatLng(48.870976, 2.35325),
          LatLng(48.871102, 2.352349),
          LatLng(48.870049, 2.351024),
          LatLng(48.8699, 2.3522),
          LatLng(48.867311, 2.344105),
        ],
      )
    ]);
  }

  BlocBuilder<MapCubit, MapState> _markerLayer() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        logger.i('Building ${locations.length} markers');
        return MarkerLayer(
          markers: locations.map((m) => _marker(context, m)).toList(),
        );
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
}
