/*view to display the list of all cities and be able to delete them */
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/main.dart';
import '../cubit/city_cubit.dart';

class CitiesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call fetchCities when the view is opened
    context.read<CityCubit>().fetchCities();

    return Scaffold(
      appBar: AppBar(
        title: Text('City List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CityCubit, List<CityModel>>(
                builder: (context, cities) {
                  if (cities.isEmpty) {
                    return Center(child: Text('No cities available.'));
                  }
                  return ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return ListTile(
                        title: Text(city.name),
                        subtitle: Text('ID: ${city.id}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<CityCubit>().removeCity(city);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
