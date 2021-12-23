import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_id TEXT,
        names TEXT,
        email TEXT,
        avatar TEXT,
        token TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tiktok.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createUser(String user_id,String names,String email,String avatar, String token) async {
    final db = await SQLHelper.db();

    final data = {
      'user_id': user_id,
      'names': names,
      'email': email,
      'avatar': avatar,
      'token': token,
      'createdAt': DateTime.now().toString()
    };
    final id = await db.insert('user', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('user', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getUser(var user_id) async {
    final db = await SQLHelper.db();
    return db.query('user', where: "user_id = ?", whereArgs: [user_id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> checkTable(var tableName) async {
    final db = await SQLHelper.db();
    return db.query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
  }

  // Update an item by id
  static Future<int> updateUser(
      int id,String user_id, String names,String email,String avatar,String token) async {
    final db = await SQLHelper.db();
    //await db.execute("DROP TABLE IF EXISTS user");

    final data = {
      'user_id': user_id,
      'names': names,
      'email': email,
      'avatar': avatar,
      'token': token,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('user', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteUser(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("user", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}