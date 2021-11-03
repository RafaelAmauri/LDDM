import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class SQLDatabase {
  static Future<Database> get database async {
    final db_path = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(db_path, 'database.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS conta(id INTEGER PRIMARY KEY, user_id INTEGER, name TEXT, due_date TEXT, description TEXT, price REAL)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, username TEXT, passwd TEXT, email TEXT)');
    }, version: 1);
  }

  static Future<int> insert(String table_name, Map<String, Object> data) async {
    final db = await SQLDatabase.database;
    return await db.insert(table_name, data,
        conflictAlgorithm: sql.ConflictAlgorithm.abort);
  }

  static Future<List<Map<String, dynamic>>> read(
      String table_name, String column, String args) async {
    final db = await SQLDatabase.database;
    return await db.query(table_name, where: '$column = ?', whereArgs: [args]);
  }

  static Future<int> update(String table_name, Map<String, Object> data) async {
    final db = await SQLDatabase.database;
    return await db.update(
      table_name,
      data,
    );
  }

  static Future<int> delete(String table_name, int data_id) async {
    final db = await SQLDatabase.database;
    return await db.delete(table_name, where: 'id = ?', whereArgs: [data_id]);
  }
}
