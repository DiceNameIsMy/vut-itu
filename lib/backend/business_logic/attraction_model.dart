class AttractionModel {
  final int id;
  final int cityId;
  final String name;
  final String description;
  final String coordinates;
  final String category;
  final double averageTime;
  final double cost;

  AttractionModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.category,
    required this.averageTime,
    required this.cost,
  });

  factory AttractionModel.fromMap(Map<String, dynamic> map) {
    return AttractionModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      cityId: map['city_id'],
      coordinates: map['coordinates'],
      category: map['category'],
      averageTime: map['average_time'].toDouble(),
      cost: map['cost'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city_id': cityId,
      'coordinates': coordinates,
      'category': category,
      'average_time': averageTime,
      'cost': cost,
    };
  }
}
