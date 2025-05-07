import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import '../models/phrase.dart';

class DatabaseService with ChangeNotifier {
  static const _databaseName = 'affirmative_sentence.db';
  static const _databaseVersion = 1;

  sql.Database? _database;

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sql.Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await sql.openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(sql.Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE phrases (
        id INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        isFavorite INTEGER DEFAULT 0,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      )
    ''');
  }

  Future<void> initialize() async {
    final db = await database;
    // 初始化預設資料
    await _loadDefaultData(db);
  }

  Future<void> _loadDefaultData(sql.Database db) async {
    // 檢查是否已有資料
    final count = sql.Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM categories')
    ) ?? 0;
    
    if (count == 0) {
      // 從JSON檔案載入預設資料
      final jsonString = await rootBundle.loadString('data/phrases.json');
      final jsonData = jsonDecode(jsonString) as List<dynamic>;
      
      for (final categoryData in jsonData) {
        // 插入分類
        await db.insert(
          'categories',
          {
            'id': categoryData['id'],
            'name': categoryData['name']
          },
        );
        
        // 插入語句
        for (final phraseData in categoryData['phrases']) {
          await db.insert(
            'phrases',
            {
              'id': phraseData['id'],
              'text': phraseData['text'],
              'categoryId': phraseData['categoryId'],
              'isFavorite': phraseData['isFavorite'] ? 1 : 0
            },
          );
        }
      }
    }
  }

  // 新增語句
  Future<int> addPhrase(Phrase phrase) async {
    final db = await database;
    return await db.insert('phrases', phrase.toJson());
  }

  // 取得所有分類
  Future<List<PhraseCategory>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return PhraseCategory(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phrases: [], // 需要另外查詢
      );
    });
  }

  // 其他CRUD操作...
}
