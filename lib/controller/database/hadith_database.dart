import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HadithDatabase {
  static late Database _db;
  //====================
  static Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'hadith.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE hadith(
          id INTEGER PRIMARY KEY,
          title TEXT,
          nuse TEXT,
          explain TEXT,
          rawy TEXT,
          note Text
          )
        ''');
      },
      version: 1,
    );
  }

  //===========
  static Future<List<Map<String, dynamic>>> getHadith() async {
    return await _db.query("hadith");
  }

//======================
  static Future<List<Map<String, dynamic>>> getHadithWithTitle(
      String title) async {
    return await _db.query("hadith", where: 'title = ?', whereArgs: [title]);
  }

  //===================
  static Future<int> addHadith(Map<String, dynamic> reminder) async {
    return await _db.insert('hadith', reminder);
  }

  //==================
  static Future<void> deleteReminder(int id) async {
    await _db.delete('hadith', where: 'id = ?', whereArgs: [id]);
  }

//=====================================================
  // Delete the entire database (for development purposes)
  static Future<void> deleteDatabases() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'hadith.db');

    await deleteDatabase(path);
    print("Database deleted successfully");
  }
}
