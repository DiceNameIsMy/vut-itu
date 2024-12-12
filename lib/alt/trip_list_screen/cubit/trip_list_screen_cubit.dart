import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

part 'trip_list_screen_state.dart';

class TripListScreenCubit extends Cubit<TripListScreenState> {
  final TripsCubit _tripsCubit;

  TripListScreenCubit(this._tripsCubit) : super(TripListScreenInitial());

  factory TripListScreenCubit.fromContext(BuildContext context) {
    return TripListScreenCubit(BlocProvider.of<TripsCubit>(context));
  }

  void addNewTripRequested() {
    var newTrip = TripModel(userId: 1, name: '', startDate: DateTime.now());
    var nameController = TextEditingController();
    nameController.addListener(() {
      nameController.value = nameController.value.copyWith(
        text: nameController.text,
        selection: TextSelection(
            baseOffset: nameController.text.length,
            extentOffset: nameController.text.length),
        composing: TextRange.empty,
      );
    });

    emit(TripListScreenAddNew(newTrip, nameController));
  }

  Future<void> refreshTripsList() async {
    await _tripsCubit.invalidateTrips();
  }
}
