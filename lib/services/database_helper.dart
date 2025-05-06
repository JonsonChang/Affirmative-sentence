import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/affirmation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('affirmations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE affirmations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        isFavorite INTEGER NOT NULL,
        category TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notification_settings (
        id INTEGER PRIMARY KEY,
        isEnabled INTEGER NOT NULL,
        activeDays TEXT NOT NULL,
        notificationTimes TEXT NOT NULL,
        randomSelection INTEGER NOT NULL
      )
    ''');

    // 初始化預設設定
    await db.insert('notification_settings', {
      'id': 1,
      'isEnabled': 1,
      'activeDays': '1,2,3,4,5',
      'notificationTimes': '09:00',
      'randomSelection': 1,
    });

    // 預設肯定語句
    await db.insert('affirmations', {
      'text': '我有能力實現我的目標',
      'isFavorite': 1,
      'category': '激勵',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> createAffirmation(Affirmation affirmation) async {
    final db = await instance.database;
    return await db.insert('affirmations', affirmation.toMap());
  }

  Future<List<Affirmation>> readAllAffirmations() async {
    final db = await instance.database;
    final result = await db.query('affirmations', orderBy: 'createdAt DESC');
    return result.map((json) => Affirmation.fromMap(json)).toList();
  }

  Future<List<Affirmation>> readFavoriteAffirmations() async {
    final db = await instance.database;
    final result = await db.query(
      'affirmations',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Affirmation.fromMap(json)).toList();
  }

  Future<int> updateAffirmation(Affirmation affirmation) async {
    final db = await instance.database;
    return await db.update(
      'affirmations',
      affirmation.toMap(),
      where: 'id = ?',
      whereArgs: [affirmation.id],
    );
  }

  Future<int> deleteAffirmation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'affirmations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
