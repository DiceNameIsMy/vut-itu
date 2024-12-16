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
    emit(List.from(_attractions)); // Emit a new list to ensure immutability
  }

  void searchAttractions(String query) {
    final filtered = _attractions
        .where((attraction) =>
            attraction.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(List.from(filtered)); // Emit a new list after filtering
  }

  void filterAttractionsByCategory(String category) {
    List<AttractionModel> filtered;

    if (category.toLowerCase() == "all") {
      // If the category is "All", return all attractions
      filtered = _attractions;
    } else {
      // Otherwise, filter by the given category
      filtered = _attractions
          .where((attraction) => attraction.category
              .toLowerCase()
              .contains(category.toLowerCase()))
          .toList();
    }

    emit(List.from(filtered)); // Emit a new list after filtering
  }

  // Hide the attraction from the list by removing it and emitting a new list
  void hideAttraction(AttractionModel attraction) {
    _attractions.remove(attraction);
    emit(List.from(
        _attractions)); // Emit a new list after removing the attraction
  }

  void addAttractionToCity(AttractionModel attraction) {
    _attractions.add(attraction);
    emit(
        List.from(_attractions)); // Emit a new list after adding the attraction
  }
}
