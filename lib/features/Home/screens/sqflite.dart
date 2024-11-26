import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertContact(String name, String phone) async {
    final db = await database;
    return await db.insert('contacts', {'name': name, 'phone': phone});
  }

  Future<List<Map<String, dynamic>>> fetchContacts() async {
    final db = await database;
    return await db.query('contacts');
  }

  Future<void> deleteAllContacts() async {
    final db = await database;
    await db.delete('contacts');
  }
}
