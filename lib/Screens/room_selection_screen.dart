import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Animation/background_animation.dart';
import 'package:llama_chat_app/Animation/dialog_box.dart';
// import 'package:llama_chat_app/BackgroundServices/background_service.dart';
import 'package:llama_chat_app/Controllers/chat_controller.dart';
import 'package:llama_chat_app/Controllers/local_database.dart';
import 'package:llama_chat_app/Widgets/e1_button.dart';
import 'package:llama_chat_app/Widgets/text_field_widget.dart';
import 'package:llama_chat_app/llama_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';

class RoomSelectionScreen extends StatefulWidget {
  const RoomSelectionScreen({super.key});

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  late final ChatController _chatController;
  final ChatDatabaseController chatDatabaseController =
      Get.put(ChatDatabaseController());
  RxBool isAnimationAllowed = true.obs; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    // BackgroundService().start();
    checkIsAnimationAllowed();
    _chatController =
        ChatController(llamaApi: LlamaApi('http://127.0.0.1:8080'));
    _loadRooms();
  }

  checkIsAnimationAllowed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAnimationAllowed.value = prefs.getBool('isAnimationAllowed') ?? true;
  }

  // Load rooms from the database
  Future<void> _loadRooms() async {
    await chatDatabaseController.loadRooms();
  }

  // Method to add a new room
  Future<void> _addRoom() async {
    final TextEditingController roomNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AnimatedDialog(
          child: AlertDialog(
            shadowColor: Colors.blue,
            backgroundColor: const Color.fromARGB(171, 0, 0, 0),
            title: Text(
              'Update Room Name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: TextFieldWidget(
              focusBorderColor: Colors.blue,
              errorBorderColor: Colors.red,
              textColor: Colors.white,
              controller: roomNameController,
              hintText: 'Enter new room name',
              hintColor: const Color.fromARGB(164, 25, 118, 210),
              fillColor: Colors.transparent,
              cursorColor: Colors.white,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final newRoom = roomNameController.text.trim();
                  if (newRoom.isNotEmpty &&
                      !chatDatabaseController.rooms.contains(newRoom)) {
                    await chatDatabaseController.saveRoom(newRoom);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(roomName: newRoom, isAnimationAllowed: isAnimationAllowed.value,),
                      ),
                    );
                  } else {
                    _showErrorDialog(
                        'Room name is either empty or already exists.');
                  }
                },
                child: Text(
                  'Create',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to delete a room
  void _deleteRoom(String roomName) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AnimatedDialog(
          child: AlertDialog(
            shadowColor: Colors.blue,
            backgroundColor: const Color.fromARGB(171, 0, 0, 0),
            title: Text(
              'Delete Room',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete "$roomName"? This action cannot be undone.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true); // Close the dialog

                  await chatDatabaseController
                      .deleteRoom(roomName); // Delete from the database
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmation == true) {
      // Also delete all messages related to the room
      await _chatController.deleteMessages(roomName);
    }
  }

  // Method to rename a room with animation
  Future<void> _updateRoomName(String oldName) async {
    final TextEditingController roomNameController =
        TextEditingController(text: oldName);

    await showDialog(
      context: context,
      builder: (context) {
        // Animation Controller to control the dialog's entrance
        return AnimatedDialog(
          child: AlertDialog(
            shadowColor: Colors.blue,
            backgroundColor: const Color.fromARGB(171, 0, 0, 0),
            title: Text(
              'Update Room Name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: TextFieldWidget(
              focusBorderColor: Colors.blue,
              errorBorderColor: Colors.red,
              textColor: Colors.white,
              controller: roomNameController,
              hintText: 'Enter new room name',
              hintColor: const Color.fromARGB(164, 25, 118, 210),
              fillColor: Colors.transparent,
              cursorColor: Colors.white,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final newRoomName = roomNameController.text.trim();
                  if (newRoomName.isEmpty) {
                    _showErrorDialog('Room name cannot be empty.');
                    return;
                  }

                  if (chatDatabaseController.rooms.contains(newRoomName) &&
                      newRoomName != oldName) {
                    _showErrorDialog('Room name already exists.');
                    return;
                  }

                  await chatDatabaseController.updateRoomName(
                      oldName, newRoomName);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: Colors.blue,
          backgroundColor: const Color.fromARGB(223, 0, 0, 0),
          title: Text(
            'Error',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var dna4thParticleAnimation =  ListView.builder(
            itemCount: chatDatabaseController.rooms.length +
                1, // +1 to add the "Create Room" button
            itemBuilder: (context, index) {
              if (index == chatDatabaseController.rooms.length) {
                // Create Room button at the end of the list
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: E1Button(
                    buttonHeight: 50,
                    buttonWidth: 200,
                    backColor: Colors.black,
                    text: 'Create Room',
                    textColor: Colors.blue,
                    onPressed: _addRoom,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: const Color.fromARGB(59, 78, 78, 78),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Colors.blue, style: BorderStyle.solid)),
                    child: ListTile(
                      title: Text(chatDatabaseController.rooms[index],
                          style: TextStyle(color: Colors.white)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _updateRoomName(
                                chatDatabaseController
                                    .rooms[index]), // Call rename method
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRoom(chatDatabaseController
                                .rooms[index]), // Call delete method
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the selected room
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                roomName: chatDatabaseController.rooms[index], isAnimationAllowed: isAnimationAllowed.value,),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          
        );
      return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Conversation Rooms',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     children: [
        //       DrawerHeader(
        //         decoration: BoxDecoration(color: Colors.blue),
        //         child: Text(
        //           'Rooms',
        //           style: TextStyle(color: Colors.white, fontSize: 24),
        //         ),
        //       ),
        //       // Display the list of rooms
        //       ...chatDatabaseController.rooms.map((room) => ListTile(
        //             title: Text(room),
        //             trailing: IconButton(
        //               icon: Icon(Icons.delete, color: Colors.red),
        //               onPressed: () {
        //                 _deleteRoom(room); // Call delete when the icon is pressed
        //               },
        //             ),
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => ChatScreen(roomName: room),
        //                 ),
        //               );
        //             },
        //           )),
        //     ],
        //   ),
        // ),
        body: isAnimationAllowed.value? DNA4thParticleAnimation(child: dna4thParticleAnimation):dna4thParticleAnimation
        
      );
    });
  }
}
