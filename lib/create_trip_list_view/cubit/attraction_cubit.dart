import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';

class AttractionCubit extends Cubit<List<AttractionModel>> {
  AttractionCubit() : super([]);

  List<AttractionModel> _attractions = [];

  Future<void> fetchAttractions(int cityId) async {
    final attractionMaps = await DatabaseHelper().getAttractions(cityId);
    _attractions =
        attractionMaps.map((map) => AttractionModel.fromMap(map)).toList();
    emit(_attractions);
  }

  void searchAttractions(String query) {
    final filtered = _attractions
        .where((attraction) =>
            attraction.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(filtered);
  }

  void filterAttractionsByCategory(String category) {
    final filtered = _attractions
        .where((attraction) =>
            attraction.category.toLowerCase().contains(category.toLowerCase()))
        .toList();
    emit(filtered);
  }

  //hide the attraction from the list
  void hideAttraction(AttractionModel attraction) {
    _attractions.remove(attraction);
    emit(_attractions);
  }

  void addAttractionToCity(AttractionModel attraction) {
    _attractions.add(attraction);
    emit(_attractions);
  }
}
