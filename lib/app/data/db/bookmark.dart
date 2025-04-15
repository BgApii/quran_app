import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._private();

  static DatabaseManager instance = DatabaseManager._private();

  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db!;
  }

  Future _initDB() async {
  Directory docDir = await getApplicationDocumentsDirectory();
  String path = join(docDir.path, "bookmark.db");
  try {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE IF NOT EXISTS bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            surah TEXT NOT NULL,
            ayah TEXT NOT NULL,
            juz TEXT NOT NULL,
            index_ayah TEXT NOT NULL,
            last_read INTEGER DEFAULT 0
          )
        ''');
      },
    );
  } catch (e) {
    print("Error initializing database: $e");
    rethrow;
  }
}

  Future closeDB() async {
    _db = await instance.db;
    _db!.close();
  }
}
