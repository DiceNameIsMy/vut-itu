part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {
  final TripModel? trip;
  final List<PlaceModel> selectedPlaces;

  OnboardingState({this.trip, this.selectedPlaces = const []});
}

final class OnboardingInitial extends OnboardingState {
  OnboardingInitial();
}

final class OnboardingScreenSetup extends OnboardingState {
  OnboardingScreenSetup();
}

final class OnboardingSelectPlaces extends OnboardingState {
  OnboardingSelectPlaces({required super.trip, required super.selectedPlaces});
}
