part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {
  final List<String> interests;

  OnboardingState({this.interests = const []});
}

final class OnboardingInitial extends OnboardingState {
  OnboardingInitial();
}

final class OnboardingCanStartPlanning extends OnboardingState {
  final TripModel trip;
  final List<TripCityModel> places;

  OnboardingCanStartPlanning(
      {required this.trip, required this.places, super.interests});
}
