import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/backend/place_model.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/trips_backend.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final TripsBackend _tripsBackend = TripsBackend();

  OnboardingCubit() : super(OnboardingInitial());

  Future<void> setup() async {
    emit(OnboardingScreenSetup());

    var trips = await _tripsBackend.getTrips();
    var firstTrip = await _getOrCreateFirstTrip(trips);

    emit(OnboardingSelectPlaces(trip: firstTrip, selectedPlaces: []));
  }

  Future<TripModel> _getOrCreateFirstTrip(List<TripModel> trips) async {
    if (trips.isNotEmpty) {
      return trips.first;
    }

    var firstTrip = TripModel(id: Uuid().v7(), title: 'My First Trip');
    await _tripsBackend.saveTrip(firstTrip);
    return firstTrip;
  }
}
