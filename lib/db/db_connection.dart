import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {
  static DbConnection? _instance;
  Database? _database;

  factory DbConnection() {
    return _instance ??= DbConnection._internal();
  }

  DbConnection._internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
    }
    return _database;
  }

  // 初期化
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weight.db');
    return openDatabase(path,
        version: 2, onCreate: _create, onUpgrade: _upgrade);
  }

  _create(Database db, int version) async {
    await db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, create_at TEXT, update_at Text)");
    await db.execute(
        "CREATE TABLE weight(user_id INTEGER , year INTEGER, month INTEGER, day INTEGER, weight REAL, create_at TEXT, update_at Text, PRIMARY KEY(user_id, year, month, day))");
  }

  _upgrade(Database db, int oldVersion, int newVersion) async {
  }
}
