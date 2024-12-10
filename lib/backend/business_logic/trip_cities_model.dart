import 'package:vut_itu/backend/business_logic/city_attractions_model.dart';

class TripCityModel {
  final int? id;
  final int tripId;
  final int cityId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int order;
  final List<CityAttractionsModel> attractions;

  TripCityModel({
    this.id,
    required this.tripId,
    required this.cityId,
    this.startDate,
    this.endDate,
    required this.order,
    this.attractions = const [],
  });

  factory TripCityModel.fromMap(Map<String, dynamic> map, {List<CityAttractionsModel> attractions = const []}) {
    return TripCityModel(
      id: map['id'],
      tripId: map['trip_id'],
      cityId: map['city_id'],
      startDate: map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      order: map['order'],
      attractions: attractions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'city_id': cityId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'order': order,
    };
  }
}
