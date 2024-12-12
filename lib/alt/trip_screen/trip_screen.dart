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
  static const maxBottomBarHeight = 500.0;

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
      bottomSheet: _bottomSheet(context),
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

  DraggableBottomSheet _bottomSheet(BuildContext context) {
    return DraggableBottomSheet(
      maxHeight: maxBottomBarHeight,
      gradientOpacity: false,
      radius: 30,
      animationDuration: Duration(milliseconds: 300),
      header: _bottomSheetHeader(context),
      body: _bottomSheetBody(context),
    );
  }

  Container _bottomSheetHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36), topRight: Radius.circular(36))),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              // Drag handle
              Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // Search bar
              Align(
                alignment: Alignment.center,
                child: SearchBar(
                  leading: Icon(Icons.search),
                  hintText: 'Search for a place',
                  onTap: () {
                    // TODO: Change bottom sheet body?
                  },
                ),
              ),
            ],
          )),
    );
  }

  Container _bottomSheetBody(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: maxBottomBarHeight,
      width: double.infinity,
      child: ReorderableListView.builder(
        itemCount: 15,
        itemBuilder: (context, idx) {
          return ListTile(
            key: Key('$idx'),
            title: Text("Unknown $idx"),
            subtitle: Text("Unknown $idx"),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          // TODO: Implement reordering
        },
      ),
    );
  }
}
