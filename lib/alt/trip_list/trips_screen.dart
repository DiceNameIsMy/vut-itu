import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map/map_screen.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/alt/trip/trip_screen.dart';

class TripsScreen extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  TripsScreen(this.settingsViewModel) : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Trips'),
            actions: [
              SettingsScreen.navigateToUsingIcon(context, settingsViewModel)
            ],
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                await BlocProvider.of<TripsCubit>(context).invalidateTrips();
              },
              child: _tripsList(state, context)),
        );
      },
    );
  }

  Widget _tripsList(TripsState state, BuildContext context) {
    return ListView.builder(
      itemCount: state.trips.length,
      itemBuilder: (context, index) {
        var (trip, places) = state.trips[index];
        return _tripItem(trip, places, context);
      },
    );
  }

  ListTile _tripItem(TripModel trip, List<TripCityModel> visitingPlaces,
      BuildContext context) {
    var subtitle = trip.startDate != null
        ? DateFormat('dd MMM, yyyy').format(trip.startDate!)
        : 'No dates';

    IconButton openMapButton;
    if (visitingPlaces.isEmpty) {
      openMapButton = IconButton(
        icon: Icon(Icons.map_rounded, color: Theme.of(context).disabledColor),
        onPressed: () {},
      );
    } else {
      openMapButton = IconButton(
        icon: Icon(Icons.map_rounded),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MapScreen(
                  trip: trip,
                  visitingPlaces: visitingPlaces,
                  centerAt: LatLng(
                      0, 0), // TODO: Add visitingPlaces.first.coordinates,
                  initZoomLevel: 7)));
        },
      );
    }

    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text(trip.name),
      subtitle: Text(subtitle),
      trailing: openMapButton,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TripScreen(
                trip: trip,
                visitingPlaces: visitingPlaces,
                settingsController: settingsViewModel)));
      },
    );
  }
}
