class TripAttractionModel {
  int? id;
  final int tripCityId;
  final int attractionId;
  DateTime? selectedDate;
  double? expectedTimeToVisitInHours;
  double? expectedCost;
  final int order;

  TripAttractionModel({
    this.id, //todo: check if this is correct
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
          map['expected_time_to_visit_in_minutes']?.toDouble(),
      expectedCost: map['expected_cost']?.toDouble(),
      order: map['order_in_list'],
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
      'order_in_list': order,
    };
  }
}
