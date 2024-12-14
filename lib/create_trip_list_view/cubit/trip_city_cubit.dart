import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';

/* This the cubit for the trip city model. It is responsible for managing the state of the trip city model. 
It manages adding TripAttraction to the list TripCity and removing from the list*/

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
    _tripCity.attractions = tripAttractions
        .map((e) => TripAttractionModel.fromMap(e))
        .toList()
        .cast<TripAttractionModel>();
    emit(_tripCity);
  }

  //add an attraction to the trip city
  Future<void> addAttractionToTripCity(AttractionModel attraction) async {
    final tripAttraction = TripAttractionModel(
        tripCityId: _tripCity.id!,
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

  //update the trip city with the new start date
  Future<void> updateTripCityStartDate(DateTime startDate) async {
    await DatabaseHelper().updateTripCity(
        _tripCity.id!, {'start_date': startDate.toIso8601String()});
    emit(_tripCity.copyWith(startDate: startDate));
  }

  //update the trip city with the new end date
  Future<void> updateTripCityEndDate(DateTime endDate) async {
    await DatabaseHelper()
        .updateTripCity(_tripCity.id!, {'end_date': endDate.toIso8601String()});
    emit(_tripCity.copyWith(endDate: endDate));
  }
}
