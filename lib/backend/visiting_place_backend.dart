import 'package:vut_itu/backend/mocks.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

class VisitingPlaceBackend {
  /// Make this class a singleton object
  static final VisitingPlaceBackend _instance =
      VisitingPlaceBackend._internal();

  VisitingPlaceBackend._internal();

  factory VisitingPlaceBackend() => _instance;

  /// In-memory storage definition
  List<VisitingPlaceModel> _visitingPlaces = mockVisitingPlaces.toList();

  Future<List<VisitingPlaceModel>> getVisitingPlaces(String tripId) async {
    await Future.delayed(Duration(seconds: 1));

    return _visitingPlaces.where((place) => place.tripId == tripId).toList();
  }

  Future<void> addVisitingPlace(VisitingPlaceModel visitingPlace) async {
    await Future.delayed(Duration(seconds: 1));

    _visitingPlaces.add(visitingPlace);
  }

  Future<void> removeVisitingPlace(String visitingPlaceId) async {
    await Future.delayed(Duration(seconds: 1));

    _visitingPlaces.removeWhere((place) => place.id == visitingPlaceId);
  }
}
