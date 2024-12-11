class TripAttractionModel {
  final int id;
  final int tripCityId;
  final int attractionId;
  final DateTime? selectedDate;
  final double? expectedTimeToVisitInHours;
  final double? expectedCost;
  final int order;

  TripAttractionModel({
    this.id = 0,
    required this.tripCityId,
    required this.attractionId,
    this.selectedDate,
    this.expectedTimeToVisitInHours,
    this.expectedCost,
    required this.order,
  });

  factory TripAttractionModel.fromMap(Map<String, dynamic> map) {
    return TripAttractionModel(
      id: map['id'],
      tripCityId: map['trip_city_id'],
      attractionId: map['attraction_id'],
      selectedDate: map['selected_date'] != null
          ? DateTime.parse(map['selected_date'])
          : null,
      expectedTimeToVisitInHours:
          map['expectedTimeToVisitInMinutes']?.toDouble(),
      expectedCost: map['expectedCost']?.toDouble(),
      order: map['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_city_id': tripCityId,
      'attraction_id': attractionId,
      'selected_date': selectedDate?.toIso8601String(),
      'expected_time_to_visit_in_minutes': expectedTimeToVisitInHours,
      'expected_cost': expectedCost,
      'order': order,
    };
  }
}
