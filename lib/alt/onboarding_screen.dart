import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/onboarding/cubit/onboarding_cubit.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip/trip_view_model.dart';
import 'package:vut_itu/trip_planning/trip_detailed_view.dart';

class OnboardingScreen extends StatefulWidget {
  final SettingsViewModel settingsController;

  const OnboardingScreen({required this.settingsController});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    var topText =
        Text("Where to?", style: Theme.of(context).textTheme.headlineLarge);

    var searchPlacesButton = Padding(
      padding: const EdgeInsets.only(
          left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
      child: const Text('TODO'),
      // child: SearchPlacesView(selectedPlaces),
    );

    var bottomText = Text("Help me decide",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
            ));

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var logo = Image(
      image: AssetImage('assets/images/triphub.png'),
      width: screenWidth * 0.8,
    );

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              logo,
              SizedBox(height: screenHeight * 0.1),
              topText,
              searchPlacesButton,
              bottomText,
              SizedBox(height: screenHeight * 0.15),
            ],
          ),
        ),
        floatingActionButton: _startPlanningFAB(),
      ),
    );
  }

  Widget? _startPlanningFAB() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
      if (state.trip == null) {
        return Column();
      }
      return Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              // Complete onboarding and navigate to the trip details view.
              widget.settingsController.completeOnboarding();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TripDetailedView(
                            tripViewModel: TripViewModel(state.trip!),
                          )),
                );
              }
            },
            icon: Icon(Icons.arrow_forward),
            label: Text("Start planning"),
          ),
        ],
      );
    });
  }
}
