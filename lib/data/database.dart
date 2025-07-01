import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static late Database db;

  LocalDatabase._();

  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'database.db');

    db = await openDatabase(path, version: 1, onOpen: (db) async {
      // creates parks table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS parks (
          id STRING PRIMARY KEY,
          name TEXT,
          type TEXT,
          entityId INTEGER,
          lat TEXT,
          lon TEXT,
          maxCapacity INTEGER,
          occupation INTEGER,
          occupationTimestamp TEXT,
          active INTEGER
        );
      ''');

      // creates parks incidents table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS park_incidents (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          parkId TEXT,
          description TEXT,
          severity INTEGER,
          datetime TEXT
        );
      ''');

      // creates giras table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS giras (
          id STRING PRIMARY KEY,
          numDocks INTEGER,
          numBikes INTEGER,
          address TEXT,
          coordinates TEXT,
          serviceLevel TEXT,
          state TEXT,
          lastUpdateTimestamp TEXT
        );
      ''');

      // creates gira incidents table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS gira_incidents (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          stationId TEXT,
          description TEXT,
          problemType TEXT,
          datetime TEXT
        );
      ''');
    });
  }
}
