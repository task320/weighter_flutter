import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weighter_flutter/db/db_connection.dart';
import 'package:weighter_flutter/dto/item_year_month.dart';

import '../entity/weight.dart';

class WeightDao {
  /// 体重データ作成
  static createWeight(
      int id, int year, int month, int day, double weight) async {
    DateTime d = DateTime.now();
    Weight weightData = Weight(
        userId: id,
        year: year,
        month: month,
        day: day,
        weight: weight,
        createAt: d.toString(),
        updateAt: d.toString());
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    await database!.insert('weight', weightData.toMap());
  }

  /// 指定月の体重データ取得
  static Future<List<Weight>> getWeightByMonth(
      int id, int year, int month) async {
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    final List<Map<String, dynamic>> maps = await database!.rawQuery(
        'select year, month, day, weight from weight where user_id = ? and year = ? and month = ? order by day desc',
        [id, year, month]);
    return List.generate(maps.length, (i) {
      return Weight(
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        weight: maps[i]['weight'],
      );
    });
  }

  /// 指定日の体重データ取得
  static Future<List<Weight>> getWeightByDay(
      int id, int year, int month, int day) async {
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    final List<Map<String, dynamic>> maps = await database!.rawQuery(
        'select year, month, day, weight from weight where user_id = ? and year = ? and month = ? and day = ? order by day desc',
        [id, year, month, day]);
    return List.generate(maps.length, (i) {
      return Weight(
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        weight: maps[i]['weight'],
      );
    });
  }

  /// 年月プルダウンアイテムデータ取得
  static Future<List<ItemYearMonth>> getInputYearMonth(int id) async {
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    final List<Map<String, dynamic>> maps = await database!.rawQuery(
        'select distinct year, month from weight where user_id = ? order by year desc, month desc',
        [id]);
    return List.generate(maps.length, (i) {
      return ItemYearMonth(maps[i]['year'], maps[i]['month']);
    }).toList();
  }

  /// 体重データ更新
  static Future<void> updateWeight(
      int id, int year, int month, int day, double weight) async {
    DateTime d = DateTime.now();
    DbConnection conn = DbConnection();
    Database? database = await conn.database;
    debugPrint(d.toString());
    await database!.rawUpdate(
        'update weight set weight = ?, update_at = ? where user_id = ? and year = ? and month = ? and day = ?',
        [weight, d.toString(), id, year, month, day]);
  }

  /// 体重データ削除
  static deleteWeight(int id) async {}
}
