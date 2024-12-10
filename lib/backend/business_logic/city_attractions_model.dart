class CityAttractionsModel {
  final int? id;
  final int tripCityId;
  final int attractionId;
  final DateTime? selectedDate;
  final double? modifiedTime; // Can override the default time of the attraction
  final double? modifiedCost; // Can override the default cost of the attraction
  final int order;

  CityAttractionsModel({
    this.id,
    required this.tripCityId,
    required this.attractionId,
    this.selectedDate,
    this.modifiedTime,
    this.modifiedCost,
    required this.order,
  });

  factory CityAttractionsModel.fromMap(Map<String, dynamic> map) {
    return CityAttractionsModel(
      id: map['id'],
      tripCityId: map['trip_city_id'],
      attractionId: map['attraction_id'],
      selectedDate: map['selected_date'] != null ? DateTime.parse(map['selected_date']) : null,
      modifiedTime: map['modified_time']?.toDouble(),
      modifiedCost: map['modified_cost']?.toDouble(),
      order: map['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_city_id': tripCityId,
      'attraction_id': attractionId,
      'selected_date': selectedDate?.toIso8601String(),
      'modified_time': modifiedTime,
      'modified_cost': modifiedCost,
      'order': order,
    };
  }
}
