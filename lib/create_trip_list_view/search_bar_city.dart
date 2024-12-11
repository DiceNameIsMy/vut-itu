import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'city_cubit.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';

class CitySearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch all cities when the widget is first loaded
    context.read<CityCubit>().fetchCities();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Cities',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (query) =>
                BlocProvider.of<CityCubit>(context).searchCities(query),
          ),
        ),
        Expanded(
          child: BlocBuilder<CityCubit, List<CityModel>>(
            builder: (context, cities) {
              if (cities.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    title: Text(city.name),
                    subtitle: Text(city.country),
                    onTap: () {
                      // Handle city selection
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
