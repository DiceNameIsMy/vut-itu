import 'package:flutter/material.dart';
import 'package:vut_itu/trip/trip_list_view_model.dart';
import 'package:vut_itu/trip/trip_view_model.dart';
//import 'package:vut_itu/trip_planning/trip_screen.dart';
import 'package:vut_itu/trip_planning/trip_detailed_view.dart';

class TripListScreen extends StatefulWidget {
  @override
  TripListScreenState createState() => TripListScreenState();
}

class TripListScreenState extends State<TripListScreen> {
  final TripListViewModel tripsList = TripListViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tripsList.loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
      ),
      body: FutureBuilder(
        future: tripsList.loadTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
                itemCount: tripsList.trips.length,
                itemBuilder: (context, index) =>
                    TripListItem(tripsList.trips[index]));
          }
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TripListItem extends StatefulWidget {
  final TripViewModel trip;

  TripListItem(this.trip);

  @override
  State<TripListItem> createState() => _TripListItemState();
}

class _TripListItemState extends State<TripListItem> {
  @override
  Widget build(BuildContext context) {
    var titleColor = widget.trip.title != null
        ? Theme.of(context).textTheme.bodyMedium?.color
        : Theme.of(context).colorScheme.secondary;

    return ListTile(
      title: Text(
        widget.trip.title ?? "Unset",
        style: TextStyle(
          color: titleColor,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailedView(tripViewModel: widget.trip)),
        );
      },
    );
  }
}
