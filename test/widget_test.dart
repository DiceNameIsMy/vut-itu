// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vut_itu/app.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/backend/settings_backend.dart';
import 'package:vut_itu/trip/trip_list_view_model.dart';

void main() {
  // TODO: Creating SettingsBackend is resulting in errors. To fix it, mock the SharedPreferencesAsync class
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final settingsController = SettingsViewModel(SettingsBackend());
    await settingsController.loadSettings();
    final tripListViewModel = TripListViewModel();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(settingsController: settingsController, tripListViewModel: tripListViewModel));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
