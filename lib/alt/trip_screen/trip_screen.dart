// ignore_for_file: require_trailing_commas

import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/map_view.dart';
import 'package:vut_itu/alt/search_bar/search_bar_view.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/alt/trip_screen/cubit/trip_screen_cubit.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class TripScreen extends StatelessWidget {
  static const maxBottomBarHeight = 500.0;

  final SettingsViewModel settingsViewModel;
  final int tripId;

  const TripScreen(
      {super.key, required this.tripId, required this.settingsViewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TripCubit.fromContext(context, tripId)..invalidateVisitingPlaces(),
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, tripState) {
          return BlocProvider(
            create: (context) => TripScreenCubit.fromContext(context),
            child: BlocBuilder<TripScreenCubit, TripScreenState>(
              builder: (context, screenState) {
                return _build(context, tripState, screenState);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _build(
    BuildContext context,
    TripState state,
    TripScreenState screenState,
  ) {
    return BottomSheetScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SearchBarView(
          settingsViewModel,
          onQuerySubmit: (locations) =>
              BlocProvider.of<TripScreenCubit>(context)
                  .showQueryResults(locations),
          onLocationSelect: (location) =>
              BlocProvider.of<TripScreenCubit>(context)
                  .selectLocation(location),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
        actions: [
          SettingsScreen.navigateToUsingIcon(context, settingsViewModel)
        ],
      ),
      body: MapView(
        trip: state.trip,
        locations: screenState.locations,
        centerAt: LatLng(51.5074, -0.1278),
        initZoomLevel: 7,
      ),
      dismissOnClick: true,
      barrierColor: Colors.white.withOpacity(0.5),

      // Configure the bottom sheet
      bottomSheet: _bottomSheet(context, state),
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

  DraggableBottomSheet _bottomSheet(BuildContext context, TripState state) {
    return DraggableBottomSheet(
      maxHeight: maxBottomBarHeight,
      gradientOpacity: false,
      radius: 30,
      animationDuration: Duration(milliseconds: 300),
      header: _bottomSheetHeader(context, state),
      body: _bottomSheetBody(context, state),
    );
  }

  Container _bottomSheetHeader(BuildContext context, TripState state) {
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
              // Trip preview
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // TODO: If text is too long, it might overflow. Fix this.
                    Text(
                      state.trip.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      ', ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    InkWell(
                      onTap: () {
                        // TODO: Impement date picker.
                        logger.w('Date picker not implemented');
                      },
                      child: Text(
                        'Dec 11 - Dec 18',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Container _bottomSheetBody(BuildContext context, TripState state) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: maxBottomBarHeight,
      width: double.infinity,
      child: ReorderableListView.builder(
        itemCount: state.places.length,
        itemBuilder: (context, idx) {
          if (state.places[idx].city == null) {
            logger.e('City is null for place $idx');
          }
          return ListTile(
            key: Key('$idx'),
            title: Text(state.places[idx].city?.name ?? 'Unknown city'),
            trailing: Icon(Icons.drag_handle),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          // TODO: Implement reordering
        },
      ),
    );
  }
}
