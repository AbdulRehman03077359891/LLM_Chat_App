// import 'package:hive_flutter/hive_flutter.dart';

// class ChatService {
//   static const String boxName = 'chatBox';

//   static Future<void> init() async {
//     await Hive.initFlutter();
//     await Hive.openBox(boxName);
//   }

//   static Future<void> saveMessage(String roomName, String role, String content) async {
//     final box = Hive.box(boxName);
//     final messages = box.get(roomName, defaultValue: []) as List;
//     messages.add({'role': role, 'content': content});
//     await box.put(roomName, messages);
//   }

//   static List<Map<String, String>> getMessages(String roomName) {
//     final box = Hive.box(boxName);
//     return List<Map<String, String>>.from(box.get(roomName, defaultValue: []));
//   }
// }
