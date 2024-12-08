part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingCanStartPlanning extends OnboardingState {
  final TripModel trip;
  final List<VisitingPlaceModel> places;

  OnboardingCanStartPlanning(this.trip, this.places);
}
