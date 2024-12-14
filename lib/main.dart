import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/alt_app.dart';
import 'package:vut_itu/bloc_change_observer.dart';
import 'package:vut_itu/app.dart';
import 'package:vut_itu/backend/gui_mode_enum.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/backend/settings_backend.dart';
import 'package:vut_itu/trip/trip_list_view_model.dart';
import 'package:vut_itu/create_trip_list_view/app.dart';

void main() async {
  Bloc.observer = const BlocChangeObserver();

  final settingsBackend = SettingsBackend();
  final settingsController = SettingsViewModel(settingsBackend);
  final tripListViewModel = TripListViewModel();

  // Before using the SettingsBackend, WidgetsFlutterBinding must be initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // TEMPORARY: For debugging the applicaiton
  await settingsBackend.setOnboardingCompleted(false);
  await settingsBackend.setGuiMode(GuiModeEnum.Nmode);

  await settingsController.loadSettings();

  // Run the app
  if (settingsController.guiMode == GuiModeEnum.defaultMode) {
    runApp(MyApp(
        settingsController: settingsController,
        tripListViewModel: tripListViewModel));
  } else if (settingsController.guiMode == GuiModeEnum.Nmode) {
    runApp(Napp(settingsController: settingsController));
  } else {
    runApp(AltApp(settingsViewModel: settingsController));
  }
}
