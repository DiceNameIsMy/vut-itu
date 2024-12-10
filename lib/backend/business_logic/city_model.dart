class CityModel {
  int id;
  String name;
  String? description;
  String? coordinates;
  String? imageUrl;

  CityModel({
    required this.id,
    required this.name,
    this.description,
    this.coordinates,
    this.imageUrl,
  });

  // Convert City object to Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coordinates': coordinates,
      'image_url': imageUrl,
    };
  }

  // Convert Map (from database) to City object
  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      coordinates: map['coordinates'],
      imageUrl: map['image_url'],
    );
  }
  
}
