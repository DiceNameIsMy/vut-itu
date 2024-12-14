import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/alt/trip_list_screen/cubit/trip_list_screen_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/alt/trip_screen/trip_screen.dart';

class TripsScreen extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  TripsScreen(this.settingsViewModel) : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, tripListState) {
        return BlocProvider(
          create: (context) => TripListScreenCubit.fromContext(context),
          child: BlocConsumer<TripListScreenCubit, TripListScreenState>(
            builder: (context, screenState) {
              return _build(context, tripListState, screenState);
            },
            listener: (context, state) async {
              if (state is! TripListScreenAddNew) {
                logger.w(
                    'Adding new trip in a modal window, but state is not AddNew');
                return;
              }
              await _showAddTripBottomSheet(context, state);
            },
          ),
        );
      },
    );
  }

  Future<dynamic> _showAddTripBottomSheet(
      BuildContext context, TripListScreenAddNew state) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        showDragHandle: true,
        builder: (context) {
          return Center(
            child: Column(
              children: [
                TextFormField(
                  controller: state.nameTextFieldController,
                  decoration: InputDecoration(
                      labelText: 'Trip name', hintText: 'Enter trip name'),
                )
                // TODO: dates + budget
                // TODO: search & select cities
                // TODO: confirm button
              ],
            ),
          );
        });
  }

  Scaffold _build(
      BuildContext context, TripsState state, TripListScreenState screenState) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trips'),
        actions: [
          SettingsScreen.navigateToUsingIcon(context, settingsViewModel)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New Trip'),
        icon: Icon(Icons.add),
        onPressed: () async {
          logger.i('New trip button pressed');
          BlocProvider.of<TripListScreenCubit>(context).addNewTripRequested();
        },
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await BlocProvider.of<TripsCubit>(context).invalidateTrips();
          },
          child: _tripsList(context, state, screenState)),
    );
  }

  Widget _tripsList(BuildContext context, TripsState tripsState,
      TripListScreenState screenState) {
    return ListView.builder(
      reverse: false,
      itemCount: tripsState.trips.length,
      itemBuilder: (context, index) {
        var (trip, places) = tripsState.trips[index];
        return _tripItem(trip, places, context);
      },
    );
  }

  ListTile _tripItem(TripModel trip, List<TripCityModel> visitingPlaces,
      BuildContext context) {
    var subtitle = trip.startDate != null
        ? DateFormat('dd MMM, yyyy').format(trip.startDate!)
        : 'No dates';

    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text(trip.name),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TripScreen(
                tripId: trip.id, settingsViewModel: settingsViewModel)));
      },
    );
  }
}
