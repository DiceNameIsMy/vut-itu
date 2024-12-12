import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/map_view.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/alt/trip_screen/cubit/trip_screen_cubit.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class TripScreen extends StatelessWidget {
  final SettingsViewModel settingsController;
  final int tripId;

  const TripScreen(
      {super.key, required this.tripId, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit.fromContext(context, tripId),
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, tripState) {
          return BlocProvider(
            create: (context) => TripScreenCubit.fromContext(context),
            child: _build(context, tripState),
          );
        },
      ),
    );
  }

  Widget _build(BuildContext context, TripState state) {
    return BottomSheetScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(state.trip.name),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
        actions: [
          SettingsScreen.navigateToUsingIcon(context, settingsController)
        ],
      ),
      body: MapView(
        trip: state.trip,
        centerAt: LatLng(53, 44),
        initZoomLevel: 7,
      ),
      dismissOnClick: true,
      barrierColor: Colors.white.withOpacity(0.5),

      // Configure the bottom sheet
      bottomSheet: DraggableBottomSheet(
          gradientOpacity: false,
          radius: 30,
          animationDuration: Duration(milliseconds: 300),
          header: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 60,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SearchBar(
                        leading: Icon(Icons.search),
                        hintText: 'Search for a place',
                      ),
                    ),
                  ],
                )),
          ),
          body: SizedBox(
              height: 500,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, idx) {
                    return ListTile(
                      title: Text("Unknown"),
                      subtitle: Text("Unknown"),
                    );
                  }))),
      onWillPop: (() async {
        if (BottomSheetPanel.isOpen) {
          BottomSheetPanel.close();
          return false;
        } else {
          return true;
        }
      }),
    );
  }
}
