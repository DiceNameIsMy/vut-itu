import 'package:flutter/material.dart';

class ActiveTripScreen extends StatefulWidget {
  @override
  _ActiveTripScreenState createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Name'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'TRIP INFO'),
            Tab(text: 'MY DOCUMENTS'),
            Tab(text: 'MANAGE PLAN'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TripInfoTab(),
          MyDocumentsTab(),
          ManagePlanTab(),
        ],
      ),
    );
  }
}

class TripInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text(
          'Next destination is:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seven Market', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.amber, size: 48),
                      SizedBox(height: 4),
                      Text('25°C', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Srážky: 2%'),
                      Text('Vlhkost: 91%'),
                      Text('Vítr: 5 km/h'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text('Trip name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              leading: Icon(Icons.location_pin),
              title: Text('W 47th & Broadway'),
              subtitle: Text('Pickup, 5:48 am'),
            ),
            ListTile(
              leading: Icon(Icons.location_pin),
              title: Text('Mean Fiddler'),
              subtitle: Text('Transit, 5:51 am'),
            ),
            ListTile(
              leading: Icon(Icons.location_pin),
              title: Text('Seven Market'),
              subtitle: Text('Destination, 6:00 am'),
            ),
          ],
        ),
      ],
    );
  }
}

class MyDocumentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        DocumentTile('Ticket Vienna-Prague', '1.4MB, 4 days ago'),
        DocumentTile('Ticket Vienna-Prague', '1.4MB, 4 days ago'),
        DocumentTile('Ticket Vienna-Prague', '1.4MB, 4 days ago'),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add),
          label: Text('Add document'),
        ),
      ],
    );
  }
}

class ManagePlanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text('Edit trip plan'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Share this trip'),
          onTap: () {},
        ),
      ],
    );
  }
}

class DocumentTile extends StatelessWidget {
  final String title;
  final String subtitle;

  DocumentTile(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
