import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabaseController extends GetxController {
  static Database? _database;

  var rooms = <String>[].obs;
  var memories = <String>[].obs;
  var prompts = <String, String>{}.obs; // Map to store prompts for each room
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initDB('chat.db');
    loadPrompts();  // Ensure prompts are loaded on initialization
    loadMemories();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 5, // Incremented version to accommodate schema updates
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Handle database schema upgrades
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        roomName TEXT,
        role TEXT,
        content TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS memory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS prompts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        roomName TEXT UNIQUE,
        prompt TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      // Add prompts table for version 5
      await db.execute('''
        CREATE TABLE IF NOT EXISTS prompts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roomName TEXT UNIQUE,
          prompt TEXT
        )
      ''');
    }
  }

  // Save a prompt for a specific room
  Future<void> savePrompt(String roomName, String prompt) async {
    final db = await database;
    await db.insert(
      'prompts',
      {'roomName': roomName, 'prompt': prompt},
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
    await loadPrompts(); // Refresh prompts
  }

  // Load all prompts into memory
  Future<void> loadPrompts() async {
    final db = await database;
    final results = await db.query('prompts');
    prompts.assignAll({
      for (var result in results)
        result['roomName'] as String: result['prompt'] as String
    });
  }

  // Delete a prompt for a specific room
  Future<void> deletePrompt(String roomName) async {
    final db = await database;
    await db.delete(
      'prompts',
      where: 'roomName = ?',
      whereArgs: [roomName],
    );
    await loadPrompts(); // Refresh prompts
  }

  // Retrieve a specific prompt for a room
  String? getPrompt(String roomName) {
    return prompts[roomName];
  }

  // Save a memory description
  Future<void> saveMemory(String description) async {
    final db = await database;
    await db.insert(
      'memory',
      {
        'description': description,
      },
    );
    await loadMemories(); // Refresh memories list
  }

  // Retrieve all memory descriptions
  Future<void> loadMemories() async {
    final db = await database;
    final results = await db.query(
      'memory',
      orderBy: 'id ASC',
    );
    memories.assignAll(results.map((result) => result['description'] as String).toList());
  }

  // Delete memory descriptions for a specific room
  Future<void> deleteMemories(String context) async {
    final db = await database;
    await db.delete(
      'memory'
    );
        await loadMemories(); // Refresh memories list
  }

  // Save a new room to the database
  Future<void> saveRoom(String roomName) async {
    final db = await database;
    await db.insert(
      'rooms',
      {'name': roomName},
    );
        await loadRooms(); // Refresh rooms list
  }

  // Retrieve all rooms
  Future<void> loadRooms() async {
    final db = await database;
    final results = await db.query('rooms');
    rooms.assignAll(results.map((room) => room['name'] as String).toList());
  }

  // Update the name of an existing room
  Future<void> updateRoomName(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'rooms',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );
        await loadRooms(); // Refresh rooms list
  }

  // Add this method to update room name in chat_history
  Future<void> updateChatHistoryRoomName(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'chat_history',
      {'roomName': newName},
      where: 'roomName = ?',
      whereArgs: [oldName],
    );
  }

  // Delete a room and its associated messages
  Future<void> deleteRoom(String roomName) async {
    final db = await database;

    // Delete messages for the room first
    await db.delete(
      'chat_history',
      where: 'roomName = ?',
      whereArgs: [roomName],
    );

    // Then delete the room itself
    await db.delete(
      'rooms',
      where: 'name = ?',
      whereArgs: [roomName],
    );
    await loadRooms(); // Refresh rooms list
  }

  // Save a message to the database
  Future<void> saveMessage(String roomName, String role, String content) async {
    final db = await database;
    await db.insert(
      'chat_history',
      {
        'roomName': roomName,
        'role': role,
        'content': content,
      },
    );
  }

  // Get all messages for a specific room
  Future<List<Map<String, String>>> getMessages(String roomName) async {
    final db = await database;
    final results = await db.query(
      'chat_history',
      where: 'roomName = ?',
      whereArgs: [roomName],
      orderBy: 'id ASC',
    );

    return results
        .map((result) => {
              'role': result['role'] as String,
              'content': result['content'] as String,
            })
        .toList();
  }
  /// Delete a specific message by its ID or content
Future<void> deleteMessage(String roomName, String content) async {
  final db = await database;
  await db.delete(
    'chat_history',
    where: 'room_name = ? AND content = ?',
    whereArgs: [roomName, content],
  );
}


  // Add this method to your ChatDatabase class:
  Future<void> deleteMessages(String roomName) async {
    final db = await database;
    await db.delete(
      'chat_history',
      where: 'roomName = ?',
      whereArgs: [roomName],
    );
  }
}
