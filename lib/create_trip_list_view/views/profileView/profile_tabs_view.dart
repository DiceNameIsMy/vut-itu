import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.black,
      indicatorWeight: 2,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(icon: Icon(Icons.grid_on)), // Posts Tab
        Tab(icon: Icon(Icons.person_pin)), // Tagged Tab
      ],
    );
  }
}
