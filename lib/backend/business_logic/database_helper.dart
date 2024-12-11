import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'trip_planner.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Cities table
    await db.execute('''
      CREATE TABLE Cities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        country TEXT NOT NULL,
        description TEXT,
        coordinates_lat REAL,
        coordinates_lng REAL,
        image_url TEXT
      )
    ''');

    // Attractions table
    await db.execute('''
      CREATE TABLE Attractions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        city_id INTEGER NOT NULL,
        coordinates_lat REAL,
        coordinates_lng REAL,
        category TEXT,
        average_time REAL,
        cost REAL,
        FOREIGN KEY (city_id) REFERENCES Cities(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
    )
    ''');

    // Trips table
    await db.execute('''
      CREATE TABLE Trips (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          start_date TEXT,
          end_date TEXT,
          budget REAL,
          user_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES Users(id)
      )
    ''');

    // TripCities table
    await db.execute('''
      CREATE TABLE TripCities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_id INTEGER NOT NULL,
        city_id INTEGER NOT NULL,
        start_date TEXT,
        end_date TEXT,
        order INTEGER NOT NULL,
        FOREIGN KEY (trip_id) REFERENCES Trips(id),
        FOREIGN KEY (city_id) REFERENCES Cities(id)
      )
    ''');

    // TripAttractions table
    await db.execute('''
      CREATE TABLE TripAttractions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_city_id INTEGER NOT NULL,
        attraction_id INTEGER NOT NULL,
        selected_date TEXT,
        expected_time_to_visit_in_minutes REAL,
        expected_cost REAL,
        order INTEGER NOT NULL,
        FOREIGN KEY (trip_city_id) REFERENCES TripCities(id),
        FOREIGN KEY (attraction_id) REFERENCES Attractions(id)
      )
    ''');

    var paris = CityModel(
      name: 'Paris',
      description: 'City of Light',
      coordinates: LatLng(48.8566, 2.3522),
      imageUrl: 'https://example.com/paris.jpg',
    );
    paris.id = await insertCity(paris.toMap()..remove('id'));

    var newYork = CityModel(
      name: 'New York',
      description: 'The Big Apple',
      coordinates: LatLng(40.7128, -74.0060),
      imageUrl: 'https://example.com/newyork.jpg',
    );

    newYork.id = await insertCity(newYork.toMap()..remove('id'));
    var tokyo = CityModel(
      name: 'Tokyo',
      description: 'The bustling capital of Japan',
      coordinates: LatLng(35.6895, 139.6917),
      imageUrl: 'https://example.com/tokyo.jpg',
    );
    tokyo.id = await insertCity(tokyo.toMap()..remove('id'));

    // Attractions
    var eiffelTower = AttractionModel(
      name: 'Eiffel Tower',
      description: 'Iconic landmark in Paris',
      cityId: paris.id,
      coordinates: LatLng(48.8584, 2.2945),
      category: 'Landmark',
      averageTime: 2.0,
      cost: 25.0,
    );
    eiffelTower.id = await insertAttraction(eiffelTower.toMap()..remove('id'));

    var louvreMuseum = AttractionModel(
      name: 'Louvre Museum',
      description: 'Famous museum with art collections',
      cityId: paris.id,
      coordinates: LatLng(48.8606, 2.3376),
      category: 'Museum',
      averageTime: 4.0,
      cost: 17.0,
    );
    louvreMuseum.id =
        await insertAttraction(louvreMuseum.toMap()..remove('id'));

    var statueOfLiberty = AttractionModel(
      name: 'Statue of Liberty',
      description: 'A symbol of freedom in New York',
      cityId: newYork.id,
      coordinates: LatLng(40.6892, -74.0445),
      category: 'Landmark',
      averageTime: 3.0,
      cost: 20.0,
    );
    statueOfLiberty.id =
        await insertAttraction(statueOfLiberty.toMap()..remove('id'));

    var centralPark = AttractionModel(
      name: 'Central Park',
      description: 'Large park in New York',
      cityId: newYork.id,
      coordinates: LatLng(40.785091, -73.968285),
      category: 'Park',
      averageTime: 2.5,
      cost: 0.0,
    );
    centralPark.id = await insertAttraction(centralPark.toMap()..remove('id'));

    var shinjukuGyoen = AttractionModel(
      name: 'Shinjuku Gyoen',
      description: 'Beautiful park in Tokyo',
      cityId: tokyo.id,
      coordinates: LatLng(35.6852, 139.7070),
      category: 'Park',
      averageTime: 2.5,
      cost: 5.0,
    );
    shinjukuGyoen.id =
        await insertAttraction(shinjukuGyoen.toMap()..remove('id'));
  }

  // Cities
  Future<int> insertCity(Map<String, dynamic> city) async {
    final db = await database;
    return await db.insert('Cities', city..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getCities() async {
    final db = await database;
    return await db.query('Cities');
  }

  Future<List<Map<String, dynamic>>> getCitiesByCountry(String country) async {
    final db = await database;
    return await db.query('Cities', where: 'country = ?', whereArgs: [country]);
  }

  Future<int> updateCity(int id, Map<String, dynamic> city) async {
    final db = await database;
    return await db.update('Cities', city, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCity(int id) async {
    final db = await database;
    return await db.delete('Cities', where: 'id = ?', whereArgs: [id]);
  }

  //  Attractions
  Future<int> insertAttraction(Map<String, dynamic> attraction) async {
    final db = await database;
    return await db.insert('Attractions', attraction..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getAttractions(int cityId) async {
    final db = await database;
    return await db
        .query('Attractions', where: 'city_id = ?', whereArgs: [cityId]);
  }

  Future<int> updateAttraction(int id, Map<String, dynamic> attraction) async {
    final db = await database;
    return await db
        .update('Attractions', attraction, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAttraction(int id) async {
    final db = await database;
    return await db.delete('Attractions', where: 'id = ?', whereArgs: [id]);
  }

  // Users
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('Users', user..remove('id'));
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.query('Users', where: 'email = ?', whereArgs: [email]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('Users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  // Trips
  Future<int> insertTrip(Map<String, dynamic> trip, int userId) async {
    final db = await database;
    trip['user_id'] = userId; // Associate trip with the user
    return await db.insert('Trips', trip..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getTripsForUser(int userId) async {
    final db = await database;
    return await db.query('Trips', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getTrips() async {
    final db = await database;
    return await db.query('Trips');
  }

  Future<int> updateTrip(int id, Map<String, dynamic> trip) async {
    final db = await database;
    return await db.update('Trips', trip, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTrip(int id) async {
    final db = await database;
    return await db.delete('Trips', where: 'id = ?', whereArgs: [id]);
  }

  // TripCities
  Future<int> insertTripCity(Map<String, dynamic> tripCity) async {
    final db = await database;
    return await db.insert('TripCities', tripCity..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getTripCities() async {
    final db = await database;
    return await db.query('TripCities');
  }

  Future<int> updateTripCity(int id, Map<String, dynamic> tripCity) async {
    final db = await database;
    return await db
        .update('TripCities', tripCity, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTripCity(int id) async {
    final db = await database;
    return await db.delete('TripCities', where: 'id = ?', whereArgs: [id]);
  }

  // TripAttractions
  Future<int> insertTripAttraction(Map<String, dynamic> tripAttraction) async {
    final db = await database;
    return await db.insert('TripAttractions', tripAttraction..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getTripAttractions() async {
    final db = await database;
    return await db.query('TripAttractions');
  }

  Future<int> updateTripAttraction(
      int id, Map<String, dynamic> tripAttraction) async {
    final db = await database;
    return await db.update('TripAttractions', tripAttraction,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTripAttraction(int id) async {
    final db = await database;
    return await db.delete('TripAttractions', where: 'id = ?', whereArgs: [id]);
  }
}
