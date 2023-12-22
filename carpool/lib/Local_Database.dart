//Local Database for storing user data
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  // Create a singleton
  static final LocalDatabase instance = LocalDatabase._init();
  // Singleton accessor
  static Database? _database;
  // Singleton constructor
  LocalDatabase._init();

  /// Retrieves the database instance asynchronously.
  /// If the database instance is already initialized, it returns the existing instance.
  /// Otherwise, it initializes a new database instance with the given name and returns it.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('your_database.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile (
        id TEXT PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        mobileNumber TEXT
      )
    ''');
  }
}
