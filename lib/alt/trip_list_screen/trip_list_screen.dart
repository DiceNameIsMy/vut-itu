import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/alt/trip_list_screen/cubit/trip_list_screen_cubit.dart';
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
      builder: (context, tripsState) {
        return BlocProvider(
          create: (context) =>
              TripListScreenCubit.fromContext(context, tripsState),
          child: BlocBuilder<TripListScreenCubit, TripListScreenState>(
            builder: (context, screenState) {
              return _build(context, tripsState, screenState);
            },
          ),
        );
      },
    );
  }

  Scaffold _build(
    BuildContext context,
    TripsState tripsState,
    TripListScreenState screenState,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trips'),
        actions: [
          SettingsScreen.navigateToUsingIcon(context, settingsViewModel),
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
        child: _tripsList(context, tripsState, screenState),
      ),
    );
  }

  Widget _tripsList(
    BuildContext context,
    TripsState tripsState,
    TripListScreenState screenState,
  ) {
    logger.i('tripsState.trips.length: ${tripsState.trips.length}');
    return ListView.builder(
      itemCount: tripsState.trips.length,
      itemBuilder: (context, index) {
        var (trip, _) = tripsState.trips[index];
        var subtitle = trip.startDate != null
            ? DateFormat('dd MMM, yyyy').format(trip.startDate!)
            : 'No dates';

        if (screenState.titleControllers[trip.id] == null) {
          var nameController = TextEditingController(text: trip.name);
          nameController.addListener(() {
            nameController.value = nameController.value.copyWith(
              text: nameController.text,
              selection: TextSelection(
                baseOffset: nameController.text.length,
                extentOffset: nameController.text.length,
              ),
              composing: TextRange.empty,
            );
          });
          screenState.titleControllers[trip.id] = nameController;
        }

        return ListTile(
          leading: Icon(Icons.directions_car),
          title: AutoSizeTextField(
            fullwidth: false,
            minLines: 1,
            maxLines: 2,
            controller: screenState.titleControllers[trip.id],
            decoration: InputDecoration(border: InputBorder.none),
            onEditingComplete: () {
              BlocProvider.of<TripListScreenCubit>(context).updateTripName(
                trip.id,
                screenState.titleControllers[trip.id]!.text,
              );
            },
          ),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.map),
          onTap: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => TripScreen(
                  tripId: trip.id,
                  settingsViewModel: settingsViewModel,
                ),
              ),
            )
                .then((_) {
              if (context.mounted) {
                BlocProvider.of<TripsCubit>(context).invalidateTrips();
              }
            });
          },
        );
      },
    );
  }
}
