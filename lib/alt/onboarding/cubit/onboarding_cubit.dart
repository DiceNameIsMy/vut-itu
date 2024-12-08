import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final TripsBackend _tripsBackend = TripsBackend();

  OnboardingCubit() : super(OnboardingInitial());

  Future<void> createFirstTrip() async {
    var trip = TripModel(id: Uuid().v7(), title: 'My First Trip');
    await _tripsBackend.saveTrip(trip);

    emit(OnboardingCanStartPlanning(trip, []));
  }
}
