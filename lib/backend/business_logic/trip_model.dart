class TripModel {
  final int id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budget;

  TripModel({
    required this.id,
    required this.name,
    this.startDate,
    this.endDate,
    this.budget,
  });

  // Convert from Map (Database row) to Trip
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'],
      name: map['name'],
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      budget: map['budget']?.toDouble(),
    );
  }

  // Convert Trip to Map (for Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'budget': budget,
    };
  }
}
