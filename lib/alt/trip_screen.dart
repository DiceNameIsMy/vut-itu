import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class TripScreen extends StatelessWidget {
  final SettingsViewModel settingsController;
  final int tripId;

  const TripScreen(
      {super.key, required this.tripId, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit.fromContext(context, tripId),
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          return _build(context, state);
        },
      ),
    );
  }

  Scaffold _build(BuildContext context, TripState state) {
    return Scaffold(
        appBar: AppBar(
          title: Text(state.trip.name),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back)),
          actions: [
            SettingsScreen.navigateToUsingIcon(context, settingsController)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(Icons.add),
          label: const Text('Add next destination'),
        ),
        body: Column(
          children: [
            Text('Places:'),
            Expanded(
              child: ListView.builder(
                itemCount: state.places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text("Unknown"), // TODO: Add visitingPlaces[index].name
                    subtitle: Text(
                        "Unknown"), // TODO: Add visitingPlaces[index].description
                  );
                },
              ),
            )
          ],
        ));
  }
}
