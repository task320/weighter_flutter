import 'package:sqflite/sqflite.dart';
import 'package:weighter_flutter/db/db_connection.dart';

import '../entity/user.dart';

class UserDao {
  /// ユーザデータ作成
  static createUser(String name) async {
    DateTime d = DateTime.now();
    User user =
        User(name: name, createAt: d.toString(), updateAt: d.toString());
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    await database!.insert('user', user.toMap());
  }

  /// ユーザデータ取得
  static getUser(int id) {}

  /// 全ユーザデータ取得
  static Future<List<User>> getAllUser() async {
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    final List<Map<String, dynamic>> maps = await database!.query('user');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        createAt: maps[i]['create_at'],
        updateAt: maps[i]['update_at'],
      );
    });
  }

  /// ユーザデータ更新
  static updateUser(int id) {}

  /// ユーザデータ削除
  static deleteUser(int id) async {
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    database!.delete('user', where: 'id = ?', whereArgs: [id]);
  }
}
