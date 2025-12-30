import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Controllers/local_database.dart';
import 'package:llama_chat_app/Screens/room_selection_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  // Initialize the ffi for desktop platforms
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    sqfliteFfiInit(); // Required for desktop platforms
    databaseFactory = databaseFactoryFfi; // Set the database factory
  }

    Get.lazyPut<ChatDatabaseController>(() => ChatDatabaseController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: RoomSelectionScreen(),
    );
  }
}
