import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_card_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_list_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_screen.dart';

class AltTripListScreen extends StatefulWidget {
  final SettingsViewModel settingsController;

  AltTripListScreen({super.key, required this.settingsController});

  @override
  State<AltTripListScreen> createState() => _AltTripListScreenState();
}

class _AltTripListScreenState extends State<AltTripListScreen> {
  final AltTripListViewModel tripListViewModel = AltTripListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SettingsScreen(
                    settingsController: widget.settingsController);
              }));
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: tripListViewModel.loadTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: tripListViewModel.trips.length,
              itemBuilder: (context, index) =>
                  _buildTripCard(tripListViewModel.trips[index], context),
            );
          }
        },
      ),
    );
  }

  ListTile _buildTripCard(AltTripCardViewModel trip, BuildContext context) {
    var subtitle = trip.arriveAt != null
        ? DateFormat('yyyy-MM-dd').format(trip.arriveAt!)
        : 'No dates';

    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text(trip.title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AltTripScreen(
                tripId: trip.id,
                settingsController: widget.settingsController)));
      },
    );
  }
}
