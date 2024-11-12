import 'package:flutter/material.dart';
import 'package:vut_itu/onboarding/search_places_view.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class OnboardingScreen extends StatefulWidget {
  final SettingsViewModel settingsController;

  const OnboardingScreen({super.key, required this.settingsController});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late SelectedPlacesViewModel selectedPlaces = SelectedPlacesViewModel();

  @override
  Widget build(BuildContext context) {
    // TODO: create a trip if none exists
    return ListenableBuilder(
        listenable: selectedPlaces,
        builder: (BuildContext context, Widget? child) {
          // Show "Start planning" button if has places selected
          FloatingActionButton? actionButton;

          if (selectedPlaces.hasAny()) {
            actionButton = FloatingActionButton.extended(
              onPressed: () {
                // TODO: Open map with first place selected
                // TODO: Save selected places to a new trip
                // TODO: Complete onboarding? So that next time app is opened it does to home screen
                widget.settingsController.completeOnboarding();
                Navigator.pushNamed(context, '/map');
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Start planning"),
            );
          }

          var topText = Text("Where to?",
              style: Theme.of(context).textTheme.headlineLarge);
          var bottomText = Text("Help me decide",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ));
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  topText,
                  SearchPlacesView(selectedPlaces),
                  bottomText,
                ],
              ),
            ),
            floatingActionButton: actionButton,
          );
        });
  }
}
