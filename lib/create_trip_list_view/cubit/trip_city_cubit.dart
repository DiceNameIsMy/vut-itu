import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';

class TripCityCubit extends Cubit<TripCityModel> {
  //initialize the cubit with an empty TripCityModel. The Id of a trip is required to create a TripCityModel
  TripCityCubit() : super(TripCityModel(tripId: 0, cityId: 0, order: 0));

  TripCityModel _tripCity = TripCityModel(tripId: 0, cityId: 0, order: 0);

  void resetTripCity() {
    _tripCity = TripCityModel(tripId: 0, cityId: 0, order: 0);
    emit(_tripCity);
  }

  //fetch trip city with attractions from the database
  Future<void> fetchTripCity(int id) async {
    final tripCity = await DatabaseHelper().getTripCity(id);
    _tripCity = TripCityModel.fromMap(tripCity);

    final tripAttractions =
        await DatabaseHelper().getTripAttractions(_tripCity);

    List<TripAttractionModel> attractionsList =
        tripAttractions.map((e) => TripAttractionModel.fromMap(e)).toList();

    attractionsList.sort((a, b) => a.order.compareTo(b.order));

    _tripCity.attractions = attractionsList;

    emit(_tripCity);
  }

  //add an attraction to the trip city
  Future<void> addAttractionToTripCity(AttractionModel attraction) async {
    final tripAttraction = TripAttractionModel(
        tripCityId: _tripCity.id,
        attractionId: attraction.id!,
        expectedCost: attraction.cost,
        expectedTimeToVisitInHours: attraction.averageTime,
        order: _tripCity.attractions!.length + 1);
    await DatabaseHelper().insertTripAttraction(tripAttraction, _tripCity);
    _tripCity.attractions!.add(tripAttraction);
    emit(_tripCity.copyWith(attractions: _tripCity.attractions));
  }

  //remove an attraction from the trip city
  Future<void> removeAttractionFromTripCity(
      TripAttractionModel attraction) async {
    await DatabaseHelper().deleteTripAttraction(attraction.id!);
    _tripCity.attractions!.remove(attraction);
    emit(_tripCity.copyWith(attractions: _tripCity.attractions));
  }

  //get attraction name by id
  Future<String> getAttractionNameById(int id) async {
    final attraction = await DatabaseHelper().getAttraction(id);
    return AttractionModel.fromMap(attraction).name;
  }

  //get attraction category by id
  Future<String> getAttractionCategoryById(int id) async {
    final attraction = await DatabaseHelper().getAttraction(id);
    return AttractionModel.fromMap(attraction).category;
  }

  //calculate the total cost of the trip city
  double calculateTotalCost() {
    double totalCost = 0;
    //check if the attractions list is not null
    if (_tripCity.attractions == null) {
      return totalCost;
    }
    for (var attraction in _tripCity.attractions!) {
      if (attraction.expectedCost != null) {
        totalCost += attraction.expectedCost!;
      }
    }
    return totalCost;
  }

  //calculate the total time of the trip city
  double calculateTotalTime() {
    double totalTime = 0;
    //check if the attractions list is not null
    if (_tripCity.attractions == null) {
      return totalTime;
    }
    for (var attraction in _tripCity.attractions!) {
      if (attraction.expectedTimeToVisitInHours != null) {
        totalTime += attraction.expectedTimeToVisitInHours!;
      }
    }
    return totalTime;
  }

  // Update the trip city with the new start date
  Future<void> updateTripCityStartDate(DateTime startDate) async {
    await DatabaseHelper().updateTripCity(
        _tripCity.id, {'start_date': startDate.toIso8601String()});

    _tripCity = _tripCity.copyWith(startDate: startDate);
    emit(_tripCity); // Emit the updated trip city state
  }

  Future<void> updateTripCityEndDate(DateTime endDate) async {
    await DatabaseHelper()
        .updateTripCity(_tripCity.id, {'end_date': endDate.toIso8601String()});

    _tripCity = _tripCity.copyWith(endDate: endDate);
    emit(_tripCity); // Emit the updated trip city state
  }

  Future<void> updateTripAttractionOrder(int id, int order) async {
    // Update the database
    await DatabaseHelper().updateTripAttraction(id, {'order_in_list': order});

    final attraction =
        _tripCity.attractions!.firstWhere((attraction) => attraction.id == id);
    attraction.order = order;

    emit(_tripCity); // Ensure state is emitted after the order is updated
  }

  Future<void> reorderAttractions(int oldIndex, int newIndex) async {
    if (state.attractions == null) return;

    if (newIndex > oldIndex) newIndex -= 1;

    final updatedAttractions = List.of(state.attractions!);

    final movedAttraction = updatedAttractions.removeAt(oldIndex);
    updatedAttractions.insert(newIndex, movedAttraction);

    for (int i = 0; i < updatedAttractions.length; i++) {
      final attraction = updatedAttractions[i];
      attraction.order = i + 1; // Update order starting from 1
      await updateTripAttractionOrder(
          attraction.id!, attraction.order); // Make sure this is awaited
    }

    emit(state.copyWith(attractions: updatedAttractions));
  }
}
