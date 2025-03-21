import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trips_cubit.dart';
import 'trip_creation_overview_view.dart';

class TripListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call fetchTrips when the view is opened
    context.read<TripsCubit>().invalidateTrips();

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TripsCubit, List<TripModel>>(
                builder: (context, trips) {
                  if (trips.isEmpty) {
                    return Center(child: Text('No trips available.'));
                  }
                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return ListTile(
                        title: Text(trip.name),
                        subtitle: Text(
                          trip.startDate == null || trip.endDate == null
                              ? ''
                              : '${'${trip.startDate!.day}.${trip.startDate!.month} - ${trip.endDate!.day}.${trip.endDate!.month}'}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<TripsCubit>().removeTrip(trip);
                          },
                        ),
                        onTap: () async {
                          // 1. Initialize the TripCubit and fetch the trip data
                          final tripCubit = TripCubit();

                          // 2. Fetch the trip data asynchronously
                          await tripCubit.fetchTrip(trip.id);

                          // 3. After the trip and associated cities are fetched, navigate to the overview
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: tripCubit, // Pass existing TripCubit
                                child: TripCreationOverviewView(
                                    tripCubit: tripCubit),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
