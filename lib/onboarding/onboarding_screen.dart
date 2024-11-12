import 'package:flutter/material.dart';
import 'package:vut_itu/onboarding/search_places_view.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  final SettingsViewModel settingsController;

  const OnboardingScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Where to?", style: Theme.of(context).textTheme.headlineLarge),
            SearchPlacesView(),
            Text("Help me decide",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open map with first place selected
          // TODO: Save selected places to a new trip
          // TODO: Complete onboarding? So that next time app is opened it does to home screen
          settingsController.completeOnboarding();
          Navigator.pushNamed(context, '/map');
        },
        icon: Icon(Icons.arrow_forward),
        label: Text("Start planning"),
      ),
    );
  }
}
