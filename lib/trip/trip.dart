class TripModel {
  TripModel({
    required this.id,
    this.title,
    this.date,
    required this.cities,
  }) : assert(cities.isNotEmpty, 'Cities list cannot be empty.');

  final String id;
  String? title;
  DateTime? date;
  final List<String> cities;
}