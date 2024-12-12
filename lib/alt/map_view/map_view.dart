import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/cubit/map_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

class MapView extends StatelessWidget {
  final TripModel trip;
  final TripCityModel? visitingPlace;
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

  MapView(
      {super.key,
      required this.trip,
      this.visitingPlace,
      required this.centerAt,
      required this.initZoomLevel});

  @override
  Widget build(BuildContext context) {
    // poi stands for Point of Interest
    var poiMarkersLayer = BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        return MarkerLayer(markers: [
          Marker(
            point: LatLng(48.8699, 2.3522),
            width: 80,
            height: 80,
            child: IconButton(
                icon: Icon(Icons.location_city, color: Colors.red),
                onPressed: () => {
                      context.read<MapCubit>().openMarkerDetails(state),
                      showModalBottomSheet(
                          context: context,
                          // TODO: Proper modal content
                          builder: (_) => Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Paris City Hall'),
                                    Text('Some description'),
                                    Text('N/A'),
                                    Text('N/A'),
                                  ],
                                ),
                              )),
                    }),
          ),
        ]);
      },
    );

    var routePolylineLayer = PolylineLayer(polylines: [
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

    return BlocProvider(
      create: (context) =>
          MapCubit(trip, visitingPlace, centerAt, initZoomLevel),
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
          children: [tileProvider, routePolylineLayer, poiMarkersLayer]),
    );
  }
}
