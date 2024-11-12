import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vut_itu/trip/trip_view_model.dart';

class TripDetailedView extends StatelessWidget {
  final TripViewModel tripViewModel;

  // Constructor
  const TripDetailedView({super.key, required this.tripViewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripViewModel>.value(
      value: tripViewModel,
      child: Consumer<TripViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Trip Details'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Text('Title:', style: Theme.of(context).textTheme.headlineMedium),
                  TextField(
                    controller: TextEditingController(text: model.title),
                    decoration: InputDecoration(hintText: 'Enter Trip Title'),
                    onSubmitted: (newTitle) {
                      model.title = newTitle; // Automatically updates backend
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Date Section
                  Text('Date:', style: Theme.of(context).textTheme.headlineMedium),
                  ListTile(
                    title: Text(model.date?.toString() ?? 'No Date Selected'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: model.date ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        model.date = selectedDate; // Automatically updates backend
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Cities Section
                  Text('Places:', style: Theme.of(context).textTheme.headlineMedium),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.places.length,
                      itemBuilder: (context, index) {
                        final city = model.places[index];
                        return ListTile(
                          title: Text(city.title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              model.removeCity(city); // Automatically updates backend
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add New City Section
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter City Name'),
                          onSubmitted: (newCity) {
                           // model.addCity(newCity); // Automatically updates backend
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // This triggers onSubmitted in the TextField
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
