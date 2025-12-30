import 'package:chatllm/Models/memory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MemoryController {
  static final MemoryController _instance = MemoryController._internal();
  factory MemoryController() => _instance;

  late Database _database;

  MemoryController._internal();

  // Initialize the database
  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ai_memory.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create table for memories
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        key TEXT,
        value TEXT,
        timestamp TEXT
      )
    ''');
  }

  // Add or update memory
  Future<void> saveMemory(String userId, String key, String value) async {
    final existingMemory = await _getMemory(userId, key);
    if (existingMemory != null) {
      // If memory exists, update it
      await _database.update(
        'memories',
        {
          'value': value,
          'timestamp': DateTime.now().toIso8601String(),
        },
        where: 'userId = ? AND key = ?',
        whereArgs: [userId, key],
      );
    } else {
      // If memory doesn't exist, insert it
      await _database.insert(
        'memories',
        {
          'userId': userId,
          'key': key,
          'value': value,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  // Get a specific memory by key
  Future<String?> getMemory(String userId, String key) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'memories',
      where: 'userId = ? AND key = ?',
      whereArgs: [userId, key],
    );

    if (maps.isNotEmpty) {
      return maps.first['value'];
    } else {
      return null;
    }
  }

  // Retrieve all memories for a specific user
  Future<List<Memory>> getAllMemories(String userId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'memories',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Memory.fromMap(maps[i]);
    });
  }

  // Delete a specific memory by key
  Future<void> deleteMemory(String userId, String key) async {
    await _database.delete(
      'memories',
      where: 'userId = ? AND key = ?',
      whereArgs: [userId, key],
    );
  }

  // Delete all memories for a user
  Future<void> deleteAllMemories(String userId) async {
    await _database.delete(
      'memories',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Helper method to get an existing memory for a key
  Future<Memory?> _getMemory(String userId, String key) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'memories',
      where: 'userId = ? AND key = ?',
      whereArgs: [userId, key],
    );

    if (maps.isNotEmpty) {
      return Memory.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
