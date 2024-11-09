import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

/// Provides a TileLayer for OpenStreetMap tiles.
///
/// This TileLayer uses the OpenStreetMap tile server to fetch map tiles.
/// The `tileProvider` is set to `CancellableNetworkTileProvider` to support the cancellation
/// of loading tiles, which is recommended for better performance and resource management.
TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      // Use the recommended flutter_map_cancellable_tile_provider package to
      // support the cancellation of loading tiles.
      tileProvider: CancellableNetworkTileProvider(),
    );
