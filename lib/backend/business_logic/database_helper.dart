import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/logger.dart';

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

    deleteDatabase(path);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    logger.d('Creating database version $version');
    await _createTables(db);
    await _insertInitialData(db);
    // await _insertMockAttractions(db);
  }

  // Cities
  Future<void> insertCity(CityModel city) async {
    final db = await database;
    city.id = await db.insert('Cities', city.toMap()..remove('id'));
  }

  Future<List<Map<String, dynamic>>> getCities() async {
    final db = await database;
    List<Map<String, dynamic>> Cities = await db.query('Cities');
    return Cities;
  }

  //get city by id
  Future<Map<String, dynamic>> getCity(int id) async {
    final db = await database;
    List<Map<String, dynamic>> city =
        await db.query('Cities', where: 'id = ?', whereArgs: [id]);

    return city.first;
  }

  Future<CityModel?> getCityByGeoapifyId(String geoapifyId) async {
    final db = await database;
    List<Map<String, dynamic>> city = await db
        .query('Cities', where: 'geoapify_id = ?', whereArgs: [geoapifyId]);

    return city.isEmpty ? null : CityModel.fromMap(city.first);
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

  Future<List<Map<String, dynamic>>> getAllAttractions() async {
    final db = await database;
    return await db.query('Attractions');
  }

  Future<Map<String, dynamic>> getAttraction(int id) async {
    final db = await database;
    List<Map<String, dynamic>> attraction =
        await db.query('Attractions', where: 'id = ?', whereArgs: [id]);
    return attraction.first;
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

  //delete all trip attractions from a trip city
  Future<int> deleteAllTripAttractions(int tripCityId) async {
    final db = await database;
    return await db.delete('TripAttractions',
        where: 'trip_city_id = ?', whereArgs: [tripCityId]);
  }

  ///

  Future<void> _createTables(Database db) async {
    // Insert some data
    // Cities
    // Cities table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        country TEXT NOT NULL,
        description TEXT,
        coordinates_lat REAL,
        coordinates_lng REAL,
        image_url TEXT,
        geoapify_id TEXT
      )
    ''');

    // To speedup lookups by geoapify_id
    await db.execute('''
      CREATE INDEX idx_geoapify_id ON Cities (geoapify_id)
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
  }

  ///
  Future<void> _insertInitialData(Database db) async {
    try {
      await db.insert(
        'Cities',
        CityModel(
          name: 'Paris',
          country: 'France',
          description: 'City of Light',
          coordinates: LatLng(48.8566, 2.3522),
          imageUrl: 'https://example.com/paris.jpg',
          geoapifyId: '',
        ).toMap()
          ..remove('id'),
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
          geoapifyId: '',
        ).toMap()
          ..remove('id'),
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
          geoapifyId: '',
        ).toMap()
          ..remove('id'),
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
        ).toMap()
          ..remove('id'),
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
        ).toMap()
          ..remove('id'),
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
          category: 'Museum',
          averageTime: 120,
          cost: 10.0,
        ).toMap()
          ..remove('id'),
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
        ).toMap()
          ..remove('id'),
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
        ).toMap()
          ..remove('id'),
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
        ).toMap()
          ..remove('id'),
      );
    } catch (e) {
      print(e);
    }
  }

  /// Database migrations management
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    logger.d('Upgrading database from $oldVersion to $newVersion');
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
            geoapifyId: '',
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
            geoapifyId: '',
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
    } else if (oldVersion < 4) {
      //add more attractions to paris
      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Arc de Triomphe',
            description: 'Iconic arch in Paris',
            cityId: 1,
            coordinates: LatLng(48.8738, 2.2950),
            category: 'Landmark',
            averageTime: 60,
            cost: 5.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Montmartre',
            description: 'Hill in Paris',
            cityId: 1,
            coordinates: LatLng(48.8867, 2.3431),
            category: 'Landmark',
            averageTime: 120,
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
            name: 'Disneyland Paris',
            description: 'Theme park in Paris',
            cityId: 1,
            coordinates: LatLng(48.8722, 2.7762),
            category: 'Theme Park',
            averageTime: 360,
            cost: 50.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }
      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Palace of Versailles',
            description: 'Royal château in Versailles',
            cityId: 1,
            coordinates: LatLng(48.8048, 2.1204),
            category: 'Landmark',
            averageTime: 180,
            cost: 20.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Sainte-Chapelle',
            description: 'Gothic chapel in Paris',
            cityId: 1,
            coordinates: LatLng(48.8555, 2.3458),
            category: 'Landmark',
            averageTime: 60,
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
            name: 'Empire State Building',
            description: 'Iconic skyscraper in New York',
            cityId: 2,
            coordinates: LatLng(40.748817, -73.985428),
            category: 'Landmark',
            averageTime: 120,
            cost: 20.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }

      try {
        await db.insert(
          'Attractions',
          AttractionModel(
            name: 'Times Square',
            description: 'Major commercial intersection in New York',
            cityId: 2,
            coordinates: LatLng(40.7580, -73.9855),
            category: 'Landmark',
            averageTime: 60,
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
            name: 'One World Trade Center',
            description: 'Tallest building in New York',
            cityId: 2,
            coordinates: LatLng(40.712742, -74.013382),
            category: 'Landmark',
            averageTime: 120,
            cost: 15.0,
          ).toMap(),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _insertMockAttractions(Database db) async {
    logger.d('Inserting mock attractions');

    List<dynamic> jsonData = json.decode(_mockAttractionsJson);

    var city = CityModel(
      name: 'Prague',
      country: 'Czech Republic',
      description: 'City of a Hundred Spires',
      coordinates: LatLng(50.0755, 14.4378),
      imageUrl: null,
      geoapifyId:
          '51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208',
    );
    logger.d(city.toMap().remove('id'));
    city.id = await db.insert('Cities', (city.toMap()..remove('id')));

    for (var item in jsonData) {
      logger.d('Inserting attraction $item');
      try {
        item['id'] = 0;
        item['city_id'] = city.id;
        AttractionModel attraction = AttractionModel.fromMap(item);

        await db.insert('Attractions', attraction.toMap()..remove('id'));
      } catch (e) {
        logger.e(e);
      }
    }
  }

  static const String _mockAttractionsJson = '''
[
    {
        "name": "Charles Bridge",
        "description": "A historic bridge that connects the Old Town and Lesser Town, adorned with Baroque statues.",
        "coordinates_lng": 14.41111,
        "coordinates_lat": 50.08689,
        "imageUrl": "https://example.com/images/charles_bridge.jpg",
        "category": "Historic Landmark",
        "cost": 0,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Prague Castle",
        "description": "One of the largest ancient castles in the world, it includes stunning architecture and historical significance.",
        "coordinates_lng": 14.40658,
        "coordinates_lat": 50.09063,
        "imageUrl": "https://example.com/images/prague_castle.jpg",
        "category": "Historic Landmark",
        "cost": 10,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Old Town Square",
        "description": "The heart of Prague, featuring the Astronomical Clock and surrounded by colorful baroque buildings.",
        "coordinates_lng": 14.42145,
        "coordinates_lat": 50.08787,
        "imageUrl": "https://example.com/images/old_town_square.jpg",
        "category": "Public Square",
        "cost": 0,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "St. Vitus Cathedral",
        "description": "A magnificent Gothic cathedral located within Prague Castle, known for its stunning stained glass windows.",
        "coordinates_lng": 14.40249,
        "coordinates_lat": 50.09064,
        "imageUrl": "https://example.com/images/st_vitus_cathedral.jpg",
        "category": "Religious Site",
        "cost": 10,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Wenceslas Square",
        "description": "A vibrant square in the New Town, known for its historical significance and shopping opportunities.",
        "coordinates_lng": 14.43042,
        "coordinates_lat": 50.07928,
        "imageUrl": "https://example.com/images/wenceslas_square.jpg",
        "category": "Public Square",
        "cost": 0,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "The Dancing House",
        "description": "An iconic modern architectural landmark, known for its unique design resembling a dancing couple.",
        "coordinates_lng": 14.41435,
        "coordinates_lat": 50.07559,
        "imageUrl": "https://example.com/images/dancing_house.jpg",
        "category": "Architectural Landmark",
        "cost": 5,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Petrin Hill and Lookout Tower",
        "description": "A large park offering beautiful gardens and a lookout tower resembling the Eiffel Tower.",
        "coordinates_lng": 14.39509,
        "coordinates_lat": 50.08349,
        "imageUrl": "https://example.com/images/petrin_hill.jpg",
        "category": "Park",
        "cost": 5,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "The Powder Tower",
        "description": "A Gothic tower that was once part of the city fortifications, now a popular tourist attraction.",
        "coordinates_lng": 14.42646,
        "coordinates_lat": 50.08745,
        "imageUrl": "https://example.com/images/powder_tower.jpg",
        "category": "Historic Landmark",
        "cost": 5,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "The Jewish Quarter",
        "description": "A historic area featuring synagogues, museums, and the Old Jewish Cemetery.",
        "coordinates_lng": 14.42076,
        "coordinates_lat": 50.09055,
        "imageUrl": "https://example.com/images/jewish_quarter.jpg",
        "category": "Cultural Site",
        "cost": 10,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Kampa Island",
        "description": "A picturesque island in the Vltava River, known for its parks and art installations.",
        "coordinates_lng": 14.40556,
        "coordinates_lat": 50.08051,
        "imageUrl": "https://example.com/images/kampa_island.jpg",
        "category": "Park",
        "cost": 0,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "Strahov Monastery",
        "description": "An ancient monastery famous for its library and beautiful gardens.",
        "coordinates_lng": 14.39486,
        "coordinates_lat": 50.08729,
        "imageUrl": "https://example.com/images/strahov_monastery.jpg",
        "category": "Religious Site",
        "cost": 5,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "John Lennon Wall",
        "description": "A colorful wall filled with John Lennon-inspired graffiti and lyrics, symbolizing peace and love.",
        "coordinates_lng": 14.39881,
        "coordinates_lat": 50.08704,
        "imageUrl": "https://example.com/images/john_lennon_wall.jpg",
        "category": "Cultural Site",
        "cost": 0,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    },
    {
        "name": "The National Museum",
        "description": "The largest museum in the Czech Republic, showcasing natural history and cultural artifacts.",
        "coordinates_lng": 14.43042,
        "coordinates_lat": 50.07835,
        "imageUrl": "https://example.com/images/national_museum.jpg",
        "category": "Museum",
        "cost": 10,
        "geoapify_id": "51ada6eb89aed72c40590a44f410320b4940f00101f9013aa5060000000000c00208",
        "average_time": 5
    }
]
''';
}
