import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vut_itu/trip/trip_view_model.dart';

class TripDetailedView extends StatelessWidget {
  final TripViewModel tripViewModel;

  // Constructor
  const TripDetailedView({Key? key, required this.tripViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tripViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trip Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title input field
              TitleInputField(tripViewModel: tripViewModel),
              SizedBox(height: 16),
              // Cities List
              CitiesList(tripViewModel: tripViewModel),
              SizedBox(height: 16),
              // Add City Button
              AddCityButton(tripViewModel: tripViewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleInputField extends StatelessWidget {
  final TripViewModel tripViewModel;
  final TextEditingController _controller = TextEditingController();

  TitleInputField({required this.tripViewModel}) {
    _controller.text = tripViewModel.title ?? ''; // Set current title
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Trip Title',
        border: OutlineInputBorder(),
      ),
      onChanged: (newTitle) {
        tripViewModel.title = newTitle;
      },
    );
  }
}

class CitiesList extends StatelessWidget {
  final TripViewModel tripViewModel;

  const CitiesList({required this.tripViewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cities:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (tripViewModel.cities.isEmpty)
          Text('No cities added yet.')
        else
          ...tripViewModel.cities.map((city) => ListTile(
                title: Text(city),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    tripViewModel.removeCity(city);
                  },
                ),
              )),
      ],
    );
  }
}

class AddCityButton extends StatelessWidget {
  final TripViewModel tripViewModel;
  final TextEditingController _cityController = TextEditingController();

  AddCityButton({required this.tripViewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Add a city',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            String city = _cityController.text.trim();
            if (city.isNotEmpty && !tripViewModel.cities.contains(city)) {
              tripViewModel.addCity(city);
              _cityController.clear(); // Clear the input field
            }
          },
        ),
      ],
    );
  }
}
