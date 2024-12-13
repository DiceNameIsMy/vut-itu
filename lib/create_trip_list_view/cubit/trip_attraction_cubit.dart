/* cubit that will manage the creation, updating and removing the tripAttraction model of a tripAttraction table of a providet TripCity*/

import 'package:bloc/bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';
import 'package:vut_itu/backend/business_logic/database_helper.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';

class TripAttractionCubit extends Cubit<List<TripAttractionModel>> {
  TripAttractionCubit() : super([]);

  List<TripAttractionModel> _tripAttractions = [];

  //fetch the tripAttractions from the database
  Future<void> fetchTripAttractions(TripCityModel tripCityModel) async {
    final tripAttractions =
        await DatabaseHelper().getTripAttractions(tripCityModel);
    _tripAttractions =
        tripAttractions.map((e) => TripAttractionModel.fromMap(e)).toList();
    emit(_tripAttractions);
  }

  //update the expected time to visit in the attraction
  Future<void> updateTripAttractionTime(int id, double time) async {
    await DatabaseHelper().updateTripAttraction(id, {'time': time});
    _tripAttractions
        .firstWhere((element) => element.id == id)
        .expectedTimeToVisitInHours = time;
    emit(_tripAttractions);
  }

  //update the tripAttraction with the new price
  Future<void> updateTripAttractionPrice(int id, double price) async {
    await DatabaseHelper().updateTripAttraction(id, {'price': price});
    _tripAttractions.firstWhere((element) => element.id == id).expectedCost =
        price;
    emit(_tripAttractions);
  }
}
