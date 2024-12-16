import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/logger.dart';

part 'trip_list_screen_state.dart';

class TripListScreenCubit extends Cubit<TripListScreenState> {
  final TripsCubit _tripsCubit;

  TripListScreenCubit(
      this._tripsCubit, Map<int, TextEditingController> titleControllers)
      : super(TripListScreenInitial(titleControllers: titleControllers));

  factory TripListScreenCubit.fromContext(
    BuildContext context,
    TripsState state,
  ) {
    var cubit = BlocProvider.of<TripsCubit>(context);
    logger.w(
        'Creating TripListScreenCubit from context with ${state.trips.length} trips');

    return TripListScreenCubit(cubit, {});
  }

  Future<void> addNewTripRequested() async {
    var newTrip =
        TripModel(userId: 1, name: 'New trip', startDate: DateTime.now());

    await _tripsCubit.createTrip(newTrip.name);
  }

  Future<void> refreshTripsList() async {
    await _tripsCubit.invalidateTrips();
  }

  Future<void> updateTripName(int tripId, String newName) async {
    await _tripsCubit.updateTripName(tripId, newName);
  }
}
