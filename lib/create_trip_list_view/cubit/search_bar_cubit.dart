import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/create_trip_list_view/cubit/city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/attraction_cubit.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';

abstract class SearchState {}

class SearchIdle extends SearchState {}

class SearchLoading extends SearchState {}

class SearchInitial extends SearchState {}

class SearchResults<T> extends SearchState {
  final List<T> results;

  SearchResults(this.results);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

class SearchCubit<T> extends Cubit<SearchState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Database instance
  final List<T> _fullSuggestions = []; // To store all suggestions locally

  SearchCubit() : super(SearchInitial());

  /// Fetch all items (cities or attractions) from the database
  Future<void> fetchAndShowAll(
      {required String type, required int? cityId}) async {
    emit(SearchLoading());
    try {
      _fullSuggestions.clear(); // Clear previous suggestions
      if (type == "city") {
        // Fetch all cities from the database
        final cityMaps = await _databaseHelper.getCities();
        _fullSuggestions
            .addAll(cityMaps.map((map) => CityModel.fromMap(map) as T));
      } else if (type == "attraction") {
        // Fetch all attractions from the database
        final attractionMaps = await _databaseHelper.getAttractions(cityId!);
        _fullSuggestions.addAll(
            attractionMaps.map((map) => AttractionModel.fromMap(map) as T));
      }

      emit(SearchResults<T>(_fullSuggestions)); // Emit all suggestions
    } catch (e) {
      emit(SearchError("Failed to fetch ${type}s: ${e.toString()}"));
    }
  }

  /// Filter suggestions based on the query
  void filter(String query) {
    if (query.isEmpty) {
      emit(SearchResults<T>(
          _fullSuggestions)); // Show all suggestions if no query
    } else {
      final filtered = _fullSuggestions
          .where((item) => (item is CityModel
                  ? (item as CityModel).name
                  : (item as AttractionModel).name)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      emit(SearchResults<T>(filtered));
    }
  }
}
