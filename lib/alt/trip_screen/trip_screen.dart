import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vut_itu/alt/device_location/cubit/device_location_cubit.dart';
import 'package:vut_itu/alt/map_view.dart';
import 'package:vut_itu/alt/search_bar/search_bar_view.dart';
import 'package:vut_itu/alt/trip/cubit/trip_cubit.dart';
import 'package:vut_itu/alt/trip_screen/cubit/trip_screen_cubit.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class TripScreen extends StatelessWidget {
  static const maxBottomBarHeight = 500.0;

  final SettingsViewModel settingsViewModel;
  final int tripId;

  const TripScreen({
    super.key,
    required this.tripId,
    required this.settingsViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TripCubit.fromContext(context, tripId)
            ..invalidateVisitingPlaces(),
        ),
        BlocProvider(
          create: (context) =>
              DeviceLocationCubit()..invalidateDeviceLocation(),
        ),
      ],
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
    List<Location> locations = switch (screenState) {
      TripScreenShowLocations() => screenState.locations,
      TripScreenShowLocationAttractions() => screenState.attractions
          .map(
            (a) => Location(
              name: a.name,
              country: screenState.location.country,
              geoapifyId: '', // TODO
              locationType: LocationType.attraction,
              latLng: a.coordinates,
            ),
          )
          .toList(),
      _ => []
    };

    return BottomSheetScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SearchBarView(
          settingsViewModel,
          onQuerySubmit: (locations) {
            BlocProvider.of<TripScreenCubit>(context)
                .showQueryResults(locations);
            // BottomSheetPanel.close();
          },
          onLocationSelect: (location) {
            BlocProvider.of<TripScreenCubit>(context).selectLocation(location);
            // BottomSheetPanel.close();
          },
          onLocationAdd: (location) async {
            var vistingAgain = await BlocProvider.of<TripScreenCubit>(context)
                .addLocation(location);

            if (!context.mounted) return;

            var snackBarText = vistingAgain
                ? '${location.name} is being added for the second time'
                : '${location.name} is being added';
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(snackBarText)));
          },
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          SettingsScreen.navigateToUsingIcon(context, settingsViewModel),
        ],
      ),
      body: MapView(
        mapController: screenState.mapController,
        trip: state.trip,
        locations: locations,
      ),
      dismissOnClick: true,
      barrierColor: Colors.white.withOpacity(0.5),

      // Configure the bottom sheet
      bottomSheet: _bottomSheet(context, state),
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
    var startDateString = state.trip.startDate != null
        ? DateFormat('dd MMM').format(state.trip.startDate!)
        : 'Unset';
    var endDateString = state.trip.endDate != null
        ? DateFormat('dd MMM').format(state.trip.endDate!)
        : 'Unset';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
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
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TODO: If text is too long, it might overflow. Fix this.
                  OutlinedButton.icon(
                    onPressed: () {
                      logger.w('Edit trip name not implemented');
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(state.trip.name),
                  ),
                  _tripDateRangePickerButton(
                    context,
                    state,
                    startDateString,
                    endDateString,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlinedButton _tripDateRangePickerButton(
    BuildContext context,
    TripState state,
    String startDateString,
    String endDateString,
  ) {
    return OutlinedButton.icon(
      onPressed: () async {
        if (!context.mounted) return;

        var cubit = BlocProvider.of<TripCubit>(context);

        var newDateRange = await showDateRangePicker(
          helpText: 'Select trip dates',
          saveText: 'Confirm',
          context: context,
          initialDateRange: DateTimeRange(
            start: state.trip.startDate ?? DateTime.now(),
            end: state.trip.endDate ?? DateTime.now(),
          ),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime(DateTime.now().year + 10),
        );

        if (newDateRange != null) {
          cubit.setStartDate(newDateRange.start);
          cubit.setEndDate(newDateRange.end);
        }
      },
      label: Text('$startDateString - $endDateString'),
      icon: Icon(Icons.calendar_today),
    );
  }

  Container _bottomSheetBody(BuildContext context, TripState state) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: maxBottomBarHeight,
      width: double.infinity,
      child: _visitingPlacesList(state, context),
    );
  }

  ReorderableListView _visitingPlacesList(
    TripState state,
    BuildContext context,
  ) {
    return ReorderableListView.builder(
      itemCount: state.places.length,
      itemBuilder: (context, idx) {
        if (state.places[idx].city == null) {
          logger.w('City ${state.places[idx].id} is not loaded yet');
        }
        return Dismissible(
          key: Key(state.places[idx].id.toString()),
          onDismissed: (direction) {
            BlocProvider.of<TripCubit>(context).removeCity(idx);

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('City was dismissed.')));
          },
          child: ListTile(
            key: Key('$idx'),
            title: Text(state.places[idx].city?.name ?? 'Loading...'),
            trailing: Icon(Icons.drag_handle),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        BlocProvider.of<TripCubit>(context).reoderPlaces(oldIndex, newIndex);
      },
    );
  }
}
