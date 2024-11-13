import 'package:flutter/material.dart';
//import 'package:vut_itu/map/map_screen.dart';
import 'package:vut_itu/onboarding/search_places_view.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip/trip_list_view_model.dart';
import 'package:vut_itu/trip_planning/trip_detailed_view.dart';
import 'package:vut_itu/active_trip/active_trip_screen.dart';


class OnboardingScreen extends StatefulWidget {
  final SettingsViewModel settingsController;
  final TripListViewModel tripListViewModel;

  const OnboardingScreen({super.key, required this.settingsController, required this.tripListViewModel});

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
              onPressed: ()  async {
          
                var newTrip = await widget.tripListViewModel.createTripFromSelectedPlaces(selectedPlaces);

                widget.settingsController.completeOnboarding();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TripDetailedView( tripViewModel: newTrip,      
                          )),
                );
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Start planning"),
            );
          }
          else {
            actionButton = FloatingActionButton.extended(
              onPressed: ()  async {
          
                widget.settingsController.completeOnboarding();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActiveTripScreen(      
                          )),
                );
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Active Trip"),
            );
          }
          var topText = Text("Where to?",
              style: Theme.of(context).textTheme.headlineLarge);
          var bottomText = Text("Help me decide",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ));

          var screenHeight = MediaQuery.of(context).size.height;
          var screenWidth = MediaQuery.of(context).size.width;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage('assets/images/triphub.png'),
                    width: screenWidth * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  topText,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
                    child: SearchPlacesView(selectedPlaces),
                  ),
                  bottomText,
                  SizedBox(height: screenHeight * 0.15),
                ],
              ),
            ),
            floatingActionButton: actionButton,
          );
        });
  }
}
