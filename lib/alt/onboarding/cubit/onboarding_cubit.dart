import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final DatabaseHelper _db = DatabaseHelper();

  final SettingsViewModel _settingsViewModel;
  final TripsCubit _tripsCubit;
  final List<String> _interests = [];

  OnboardingCubit(this._tripsCubit, this._settingsViewModel)
      : super(OnboardingInitial());

  OnboardingCubit.fromContext(
      BuildContext context, SettingsViewModel settingsViewModel)
      : this(BlocProvider.of<TripsCubit>(context), settingsViewModel);

  Future<void> createFirstTrip() async {
    var trip = TripModel(userId: 0, name: 'My First Trip');
    await _db.insertTrip(trip);

    // TODO: Convert to a cubit/bloc
    await _settingsViewModel.completeOnboarding();

    emit(OnboardingCanStartPlanning(trip: trip, places: []));

    _tripsCubit.invalidateTrips();
  }

  Future<void> addInterest(String interest) async {
    _interests.add(interest);
  }
}
