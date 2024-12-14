import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';

class SelectedPlacesCubit extends Cubit<List<CityModel>> {
  SelectedPlacesCubit() : super([]);

  void addPlace(CityModel city) {
    if (!state.contains(city)) {
      emit([...state, city]);
    }
  }

  void removePlace(CityModel city) {
    emit(state.where((c) => c != city).toList());
  }

  void clearPlaces() {
    emit([]);
  }
}
