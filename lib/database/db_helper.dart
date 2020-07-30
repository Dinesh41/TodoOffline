import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DbActions { NONE, NEW, UPDATED, DELETED }

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();
  static final int version = 1;

  static Database _database;

  static Future<Database> get database async {
    if (_database != null) {
      _database.execute("PRAGMA foreign_keys=ON");
      return _database;
    }
    ;

    // if _database is null we instantiate it
    _database = await initDB();
    _database.execute("PRAGMA foreign_keys=ON");
    return _database;
  }

  static Future<Database> initDB() async {
    String path = await getDatabasesPath();
    print(path);
    return openDatabase(join(path, 'todo_offline.db'), onCreate: (db, version) {
      var database = db.execute(
        "CREATE TABLE images(storage_ref TEXT PRIMARY KEY,local_path TEXT NOT NULL);",
      );
      return database;
    }, version: version);
  }
}
