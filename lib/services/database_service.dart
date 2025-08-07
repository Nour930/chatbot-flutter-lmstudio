import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:chatbot/models/message.dart';  // Changé ici

class DatabaseService {
  static Database? _database;
  static const String tableName = 'messages';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chatbot.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, text TEXT, isUser INTEGER, timestamp INTEGER)',
        );
      },
    );
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert(
      tableName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  Future<void> clearMessages() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> deleteMessage(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
