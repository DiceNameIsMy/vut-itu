import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';

class TripModel {
  int id;
  final int userId;
  String name;
  DateTime? startDate;
  DateTime? endDate;
  double? budget;
  List<TripCityModel> cities;

  TripModel({
    this.id = 0,
    this.userId = 1,
    this.name = '',
    this.startDate,
    this.endDate,
    this.budget,
    List<TripCityModel>? cities,
  }) : cities = cities ?? [];

  // Factory constructor for converting a Map (from database) to TripModel
  factory TripModel.fromMap(Map<String, dynamic> map,
      {List<TripCityModel> cities = const []}) {
    return TripModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      budget: map['budget']?.toDouble(),
      cities: cities,
    );
  }

  // Method for converting TripModel to a Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'budget': budget,
    };
  }

  // Optional: Add a method for updating cities separately
  TripModel copyWith({
    int? id,
    int? userId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    List<TripCityModel>? cities,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      cities: cities ?? this.cities,
    );
  }
}
