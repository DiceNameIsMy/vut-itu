import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';

class CityCubit extends Cubit<List<CityModel>> {
  CityCubit() : super([]);

  List<CityModel> _cities = [];

  Future<void> fetchCities() async {
    try {
      final cityMaps = await DatabaseHelper().getCities();
      _cities = cityMaps.map((map) => CityModel.fromMap(map)).toList();
      emit(_cities);
    } catch (error) {
      //todo error
    }
  }

  void searchCities(String query) {
    final filtered = _cities
        .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(filtered);
  }
}
