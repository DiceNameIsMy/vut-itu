import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vut_itu/alt/onboarding_screen/cubit/onboarding_cubit.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/alt/trip_screen/trip_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  const OnboardingScreen({super.key, required this.settingsViewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OnboardingCubit.fromContext(context, settingsViewModel)
            ..createFirstTrip(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return _build(state, context);
        },
      ),
    );
  }

  Widget _build(OnboardingState state, BuildContext context) {
    return IntroductionScreen(
      showBackButton: true,
      showNextButton: true,
      next: const Icon(Icons.arrow_forward),
      back: const Icon(Icons.arrow_back),
      pages: [
        PageViewModel(
          title: 'Title of introduction page',
          body: 'Welcome to the app! This is a description of how it works.',
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: 'Title of introduction page 2',
          body: 'Welcome to the app! This is a description of how it works.',
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
      ],
      done: state is OnboardingCanStartPlanning
          ? Text('Get Started')
          : Container(),
      onDone: () {
        if (state is OnboardingCanStartPlanning) {
          settingsViewModel.completeOnboarding();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return TripScreen(
                  tripId: state.trip.id,
                  settingsViewModel: settingsViewModel,
                );
              },
            ),
          );
        }
        logger.e(
          'Reached end of onboarding without being able to actually start planning',
        );
      },
    );
  }
}
