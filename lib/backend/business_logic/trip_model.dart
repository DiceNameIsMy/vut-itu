class TripModel {
  int id;
  final int userId;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budget;

  TripModel({
    this.id = 0,
    required this.userId,
    required this.name,
    this.startDate,
    this.endDate,
    this.budget,
  });

  // Convert from Map (Database row) to Trip
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'],
      userId: map['user_id'],
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
      'user_id': userId,
      'name': name,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'budget': budget,
    };
  }
}
