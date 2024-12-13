import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';

/// Represents a city to visit in a trip.
class TripCityModel {
  int? id;
  final int tripId;
  final int cityId;
  DateTime? startDate;
  DateTime? endDate;
  final int order;

  /// Optionally loaded from the database. If null then it was not loaded yet.
  final CityModel? city;
  List<TripAttractionModel>? attractions;

  TripCityModel({
    this.id = 0, // todo: check if this is correct
    required this.tripId,
    required this.cityId,
    this.startDate,
    this.endDate,
    required this.order,
    this.city,
    this.attractions,
  });

  factory TripCityModel.fromMap(Map<String, dynamic> map,
      {List<TripAttractionModel>? attractions, CityModel? city}) {
    return TripCityModel(
      id: map['id'],
      tripId: map['trip_id'],
      cityId: map['city_id'],
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      order: map['order_in_list'],
      attractions: attractions,
      city: city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'city_id': cityId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'order_in_list': order,
    };
  }

  TripCityModel copyWith({
    int? id,
    int? tripId,
    int? cityId,
    DateTime? startDate,
    DateTime? endDate,
    int? order,
    CityModel? city,
    List<TripAttractionModel>? attractions,
  }) {
    return TripCityModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      cityId: cityId ?? this.cityId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      order: order ?? this.order,
      city: city ?? this.city,
      attractions: attractions ?? this.attractions,
    );
  }
}
