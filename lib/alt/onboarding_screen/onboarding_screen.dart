import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/onboarding_screen/cubit/onboarding_cubit.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/alt/trip_screen/trip_screen.dart';

class OnboaringScreen extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  const OnboaringScreen({super.key, required this.settingsViewModel});

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

  Scaffold _build(OnboardingState state, BuildContext context) {
    FloatingActionButton? fab;
    if (state is OnboardingCanStartPlanning) {
      fab = FloatingActionButton.extended(
          onPressed: () {
            settingsViewModel.completeOnboarding();
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return TripScreen(
                  tripId: state.trip.id, settingsController: settingsViewModel);
            }));
          },
          label: Text('Let\'s go'));
    }

    return Scaffold(
      body: Center(
        child: Center(child: Text('Onboarding Screen')),
      ),
      floatingActionButton: fab,
    );
  }
}
