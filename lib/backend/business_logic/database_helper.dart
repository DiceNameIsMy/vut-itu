import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

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
    String path = join(dbPath, 'trip_planning.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Cities table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cities (
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
      CREATE TABLE IF NOT EXISTS Attractions (
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
      CREATE TABLE IF NOT EXISTS Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
    )
    ''');

    // Trips table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Trips (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          start_date TEXT,
          end_date TEXT,
          budget REAL,
          FOREIGN KEY (user_id) REFERENCES Users(id)
      )
    ''');

    // TripCities table
    await db.execute('''
     CREATE TABLE IF NOT EXISTS TripCities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_id INTEGER NOT NULL,
        city_id INTEGER NOT NULL,
        start_date TEXT,
        end_date TEXT,
        order_in_list INTEGER NOT NULL,
        FOREIGN KEY (trip_id) REFERENCES Trips(id),
        FOREIGN KEY (city_id) REFERENCES Cities(id)
      )
    ''');

    // TripAttractions table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS TripAttractions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_city_id INTEGER NOT NULL,
        attraction_id INTEGER NOT NULL,
        selected_date TEXT,
        expected_time_to_visit_in_minutes REAL,
        expected_cost REAL,
        order_in_list INTEGER NOT NULL,
        FOREIGN KEY (trip_city_id) REFERENCES TripCities(id),
        FOREIGN KEY (attraction_id) REFERENCES Attractions(id)
      )
    ''');

    //   // Insert some data
    //   // Cities
    try {
      await db.insert(
        'Cities',
        CityModel(
          name: 'Paris',
          country: 'France',
          description: 'City of Light',
          coordinates: LatLng(48.8566, 2.3522),
          imageUrl: 'https://example.com/paris.jpg',
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Cities',
        CityModel(
          name: 'New York',
          country: 'USA',
          description: 'The Big Apple',
          coordinates: LatLng(40.7128, -74.0060),
          imageUrl: 'https://example.com/newyork.jpg',
        ).toMap(),
      );
      print('New York inserted');
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Cities',
        CityModel(
          name: 'Tokyo',
          country: 'Japan',
          description: 'The Capital of Japan',
          coordinates: LatLng(35.6895, 139.6917),
          imageUrl: 'https://example.com/tokyo.jpg',
        ).toMap(),
      );
      print('Tokyo inserted');
    } catch (e) {
      print(e);
    }

    // Attractions
    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Eiffel Tower',
          description: 'Iconic wrought-iron lattice tower',
          cityId: 1,
          coordinates: LatLng(48.8584, 2.2945),
          category: 'Landmark',
          averageTime: 120,
          cost: 10.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Louvre Museum',
          description: 'World\'s largest art museum',
          cityId: 1,
          coordinates: LatLng(48.8606, 2.3376),
          category: 'Museum',
          averageTime: 180,
          cost: 15.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Statue of Liberty',
          description: 'Iconic statue in New York Harbor',
          cityId: 2,
          coordinates: LatLng(40.6892, -74.0445),
          category: 'Landmark',
          averageTime: 120,
          cost: 10.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Central Park',
          description: 'Urban park in New York City',
          cityId: 2,
          coordinates: LatLng(40.785091, -73.968285),
          category: 'Park',
          averageTime: 180,
          cost: 0.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Tokyo Tower',
          description: 'Iconic communications and observation tower',
          cityId: 3,
          coordinates: LatLng(35.6586, 139.7454),
          category: 'Landmark',
          averageTime: 120,
          cost: 10.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }

    try {
      await db.insert(
        'Attractions',
        AttractionModel(
          name: 'Shibuya Crossing',
          description: 'Busiest pedestrian crossing in the world',
          cityId: 3,
          coordinates: LatLng(35.6590, 139.7006),
          category: 'Landmark',
          averageTime: 60,
          cost: 0.0,
        ).toMap(),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.insert(
          'Cities',
          CityModel(
            name: 'New York',
            country: 'USA',
            description: 'The Big Apple',
            coordinates: LatLng(40.7128, -74.0060),
            imageUrl: 'https://example.com/newyork.jpg',
          ).toMap(),
        );
        print('New York inserted');
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Cities',
          CityModel(
            name: 'Tokyo',
            country: 'Japan',
            description: 'The Capital of Japan',
            coordinates: LatLng(35.6895, 139.6917),
            imageUrl: 'https://example.com/tokyo.jpg',
          ).toMap(),
        );
        print('Tokyo inserted');
      } catch (e) {
        print(e);
      }

      // Attractions
      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Eiffel Tower',
            description: 'Iconic wrought-iron lattice tower',
            cityId: 1,
            coordinates: LatLng(48.8584, 2.2945),
            category: 'Landmark',
            averageTime: 120,
            cost: 10.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Louvre Museum',
            description: 'World\'s largest art museum',
            cityId: 1,
            coordinates: LatLng(48.8606, 2.3376),
            category: 'Museum',
            averageTime: 180,
            cost: 15.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Statue of Liberty',
            description: 'Iconic statue in New York Harbor',
            cityId: 2,
            coordinates: LatLng(40.6892, -74.0445),
            category: 'Landmark',
            averageTime: 120,
            cost: 10.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Central Park',
            description: 'Urban park in New York City',
            cityId: 2,
            coordinates: LatLng(40.785091, -73.968285),
            category: 'Park',
            averageTime: 180,
            cost: 0.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Tokyo Tower',
            description: 'Iconic communications and observation tower',
            cityId: 3,
            coordinates: LatLng(35.6586, 139.7454),
            category: 'Landmark',
            averageTime: 120,
            cost: 10.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Shibuya Crossing',
            description: 'Busiest pedestrian crossing in the world',
            cityId: 3,
            coordinates: LatLng(35.6590, 139.7006),
            category: 'Landmark',
            averageTime: 60,
            cost: 0.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  // Cities
  Future<void> insertCity(CityModel city) async {
    final db = await database;
    city.id = await db.insert('Cities', city.toMap()..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getCities() async {
    final db = await database;
    List<Map<String, dynamic>> Cities = await db.query('Cities');
    print(Cities);
    final result = await db.rawQuery('SELECT * FROM Cities');
    print(result);
    return Cities;
  }

  //get city by id
  Future<Map<String, dynamic>> getCity(int id) async {
    final db = await database;
    List<Map<String, dynamic>> city =
        await db.query('Cities', where: 'id = ?', whereArgs: [id]);
    return city.first;
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
  Future<void> insertAttraction(AttractionModel attraction) async {
    final db = await database;
    attraction.id =
        await db.insert('Attractions', attraction.toMap()..remove('id'));
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

  // Trips
  // Insert a trip into the database
  Future<void> insertTrip(TripModel trip) async {
    final db = await database;
    trip.id = await db.insert('Trips', trip.toMap()..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getTripsForUser(int userId) async {
    final db = await database;
    return await db.query('Trips', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getTrips({
    String? orderByField,
    bool orderByAsc = true,
  }) async {
    final db = await database;
    var orderBy = orderByField == null
        ? null
        : '$orderByField ${orderByAsc ? 'ASC' : 'DESC'}';

    return await db.query('Trips', orderBy: orderBy);
  }

  Future<Map<String, dynamic>> getTrip(int id) async {
    final db = await database;
    List<Map<String, dynamic>> trip =
        await db.query('Trips', where: 'id = ?', whereArgs: [id]);
    return trip.first;
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
  Future<TripCityModel> insertSingleTripCity(TripCityModel tripCity) async {
    final db = await database;
    final id = await db.insert('TripCities', tripCity.toMap()..remove('id'));
    tripCity.id = id;
    return tripCity;
  }

  Future<List<Map<String, dynamic>>> getTripCities({required tripId}) async {
    final db = await database;
    return await db
        .query('TripCities', where: 'trip_id = ?', whereArgs: [tripId]);
  }

  //get trip city by id
  Future<Map<String, dynamic>> getTripCity(int id) async {
    final db = await database;
    List<Map<String, dynamic>> tripCity =
        await db.query('TripCities', where: 'id = ?', whereArgs: [id]);
    return tripCity.first;
  }

  //do I use this? todo
  Future<List<TripCityModel>> getTripCitiesWithAll({required tripId}) async {
    final db = await database;
    var tripCitiesMapping =
        await db.query('TripCities', where: 'trip_id = ?', whereArgs: [tripId]);

    var futures = <Future>[];

    var attractions =
        List<List<TripAttractionModel>?>.filled(tripCitiesMapping.length, null);
    var cities = List<CityModel?>.filled(tripCitiesMapping.length, null);

    tripCitiesMapping.asMap().forEach((idx, tripCity) {
      // Add Future: Load attractions
      futures.add(db.query('TripAttractions',
          where: 'trip_city_id = ?',
          whereArgs: [tripCity['id']]).then((mapping) async {
        attractions[idx] =
            mapping.map((e) => TripAttractionModel.fromMap(e)).toList();
      }));

      // Add Future: Load city
      futures.add(db.query('Cities',
          where: 'id = ?',
          whereArgs: [tripCity['city_id']]).then((cityMapping) async {
        if (cityMapping.isNotEmpty) {
          cities[idx] = CityModel.fromMap(cityMapping.first);
        }
      }));
    });

    await Future.wait(futures);

    var tripCities = <TripCityModel>[];
    tripCitiesMapping.asMap().forEach((idx, tripCity) {
      tripCities.add(TripCityModel.fromMap(tripCity,
          attractions: attractions[idx], city: cities[idx]));
    });

    return tripCities;
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
// Insert a tripAttraction into the database to the provided TripCity
  Future<void> insertTripAttraction(
      TripAttractionModel tripAttraction, TripCityModel tripCity) async {
    final db = await database;
    tripAttraction.id = await db.insert(
        'TripAttractions',
        tripAttraction.toMap()
          ..remove('id')
          ..addAll({'trip_city_id': tripCity.id}));
  }

  Future<List<Map<String, dynamic>>> getTripAttractions(
      TripCityModel TripCityModel) async {
    final db = await database;
    return await db.query('TripAttractions',
        where: 'trip_city_id = ?', whereArgs: [TripCityModel.id]);
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
