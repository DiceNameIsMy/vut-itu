import 'package:flutter/material.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';

class CityViewModel extends ChangeNotifier {
  List<CityModel> _cities = [];
  bool _isLoading = false;

  List<CityModel> get cities => _cities;
  bool get isLoading => _isLoading;

  // Method to fetch cities from the database
  Future<void> fetchCities() async {
    _isLoading = true;
    notifyListeners(); // Notify UI to update loading state
    try {
      final citiesData = await DatabaseHelper().getCities();
      _cities = citiesData.map((cityData) => CityModel.fromMap(cityData)).toList();
    } catch (e) {
      // Handle error
      print('Error fetching cities: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to update after data fetch
    }
  }
}
