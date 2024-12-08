import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final TripsBackend _tripsBackend = TripsBackend();

  final SettingsViewModel _settingsViewModel;
  final TripsCubit _tripsCubit;

  OnboardingCubit(this._tripsCubit, this._settingsViewModel)
      : super(OnboardingInitial());

  OnboardingCubit.fromContext(
      BuildContext context, SettingsViewModel settingsViewModel)
      : this(BlocProvider.of<TripsCubit>(context), settingsViewModel);

  Future<void> createFirstTrip() async {
    var trip = TripModel(id: Uuid().v7(), title: 'My First Trip');
    await _tripsBackend.saveTrip(trip);

    // TODO: Convert to a cubit/bloc
    await _settingsViewModel.completeOnboarding();

    emit(OnboardingCanStartPlanning(trip, []));

    _tripsCubit.invalidateTrips();
  }
}
