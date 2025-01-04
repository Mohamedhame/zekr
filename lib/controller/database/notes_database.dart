import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static late Database _db;

  static Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'reminders.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminder(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          isActive INTEGER,
          remindersTime TEXT,
          category TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  //===========
  static Future<List<Map<String, dynamic>>> getReminders() async {
    return await _db.query("reminder");
  }

  //=============
  static Future<Map<String, dynamic>?> getRemindersById(int id) async {
    final List<Map<String, dynamic>> results =
        await _db.query('reminder', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  //===================
  static Future<int> addReminder(Map<String, dynamic> reminder) async {
    return await _db.insert('reminder', reminder);
  }

  //===================
  static Future<void> updateReminder(
      int id, Map<String, dynamic> reminder) async {
    await _db.update('reminder', reminder, where: 'id = ?', whereArgs: [id]);
  }

  //=================
  static Future<void> deleteReminder(int id) async {
    await _db.delete('reminder', where: 'id = ?', whereArgs: [id]);
  }

  //=================
  static Future<void> toggleReminder(int id, bool isActive) async {
    await _db.update('reminder', {'isActive': isActive ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }
  //=============
  static Future<void> resetIdIfEmpty() async {
  final dbPath = await getDatabasesPath();
  final databasePath = join(dbPath, 'reminders.db');

  final db = await openDatabase(databasePath);

  final List<Map<String, dynamic>> results = await db.query('reminder');

  if (results.isEmpty) {
    await db.close();
    await deleteDatabase(databasePath);

    await initDb();
  } else {
    print("Database contains ${results.length} items.");
  }
}
}
