import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_screen.dart';

class TripsScreen extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  TripsScreen(this.settingsViewModel) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsCubit()..fetchTrips(),
      child: BlocBuilder<TripsCubit, TripsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Trips'),
              actions: [
                SettingsScreen.navigateToUsingIcon(context, settingsViewModel)
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<TripsCubit>().fetchTrips();
              },
              child: const Icon(Icons.add),
            ),
            body: _tripsList(state, context),
          );
        },
      ),
    );
  }

  Center _tripsList(TripsState state, BuildContext context) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        children: state.trips.map((trip) => _tripCard(trip, context)).toList(),
      ),
    );
  }

  ListTile _tripCard(TripModel trip, BuildContext context) {
    var subtitle = trip.arriveAt != null
        ? DateFormat('yyyy-MM-dd').format(trip.arriveAt!)
        : 'No dates';

    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text(trip.title ?? 'unset'),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AltTripScreen(
                tripId: trip.id, settingsController: settingsViewModel)));
      },
    );
  }
}
