import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Animation/background_animation.dart';
import 'package:llama_chat_app/Controllers/chat_controller.dart';
import 'package:llama_chat_app/Controllers/local_database.dart';
import 'package:llama_chat_app/Controllers/stt_controller.dart';
import 'package:llama_chat_app/Controllers/tts_controller.dart';
import 'package:llama_chat_app/Screens/ai_settings.dart';
import 'package:llama_chat_app/Screens/live_chat.dart';
import 'package:llama_chat_app/Screens/memory_management_screen.dart';
import 'package:llama_chat_app/Screens/prompt_setting_screen.dart';
import 'package:llama_chat_app/Screens/tts_screen.dart';
import 'package:llama_chat_app/Widgets/drawer.dart';
import 'package:llama_chat_app/Widgets/text_field_widget.dart';
import 'package:llama_chat_app/llama_api.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String roomName;
  final bool isAnimationAllowed;

  const ChatScreen(
      {super.key, required this.roomName, required this.isAnimationAllowed});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController =
      Get.put(ChatController(llamaApi: LlamaApi('http://127.0.0.1:8080')));
  final ChatDatabaseController chatDatabaseController =
      Get.put(ChatDatabaseController());
  late final SttController sttController;
  late final TtsController ttsController;

  @override
  void initState() {
    super.initState();
    // Initialize SttController and TtsController with dependency injection
    sttController =
        Get.put(SttController(llamaApi: LlamaApi('http://127.0.0.1:8080')));
// Only initialize TtsController if it is not already available
    if (!Get.isRegistered<TtsController>()) {
      ttsController = Get.put(TtsController(sttController: sttController));
    } else {
      // Get the already registered TtsController if it exists
      ttsController = Get.find<TtsController>();
    }
    sttController.setTtsController(ttsController);

    _loadMessages();
  }

  @override
  void dispose() {
    // Dispose of controllers if you no longer need them
    Get.delete<SttController>();
    Get.delete<TtsController>();

    super.dispose();
  }

  Future<void> _loadMessages() async {
    // Defer the state change until after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.messages.clear(); // Clear messages safely
    });
    // Load new messages for the selected room
    final savedMessages = await chatController.loadMessages(widget.roomName);
    // Add new messages safely after the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.messages.addAll(savedMessages);
    });
  }

  void _sendMessage() async {
    await chatController.rememberConversation(widget.roomName);
  }

  void _navigateToRoom(String roomName) {
    // Dispose controllers before navigating
    if (widget.roomName != roomName) {
      Get.delete<SttController>();
      Get.delete<TtsController>();
    }
    chatController.navigateToRoom(context, widget.roomName, roomName, widget.isAnimationAllowed);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied to clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var column = Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        chatController.messages.length - 1 - index;
                    final message = chatController.messages[reversedIndex];
                    final isUser = message['role'] == 'user';
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                border: isUser
                                    ? Border(
                                        bottom:
                                            BorderSide(color: Colors.white54),
                                        left: BorderSide(color: Colors.white54),
                                        top: BorderSide(color: Colors.white54))
                                    : Border(
                                        bottom:
                                            BorderSide(color: Colors.white54),
                                        right:
                                            BorderSide(color: Colors.white54),
                                        top: BorderSide(color: Colors.white54)),
                                color: isUser ? Colors.white24 : Colors.black45,
                                borderRadius: isUser
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                              ),
                              child: Text(
                                message['content']!,
                                style: TextStyle(
                                    color:
                                        isUser ? Colors.white : Colors.white),
                              ),
                            ),
                          ),
                          isUser
                              ? Positioned(
                                  left: 20,
                                  bottom: -10,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.copy,
                                            color: Colors.blue.shade400,
                                            size: 15),
                                        onPressed: () => _copyToClipboard(
                                            message['content']!),
                                      ),
                                    ],
                                  ),
                                )
                              : Positioned(
                                  right: 20,
                                  bottom: -10,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.copy,
                                            color: Colors.lightBlue.shade400,
                                            size: 15),
                                        onPressed: () => _copyToClipboard(
                                            message['content']!),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.volume_up,
                                            color: Colors.lightBlue.shade400,
                                            size: 15),
                                        onPressed: () =>
                                            ttsController.speakText(message[
                                                'content']!), // Speak the message
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (chatController.isLoading.value)
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 10,
                        width: 60,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballPulseSync,

                            /// Required, The loading type of the widget
                            colors: [
                              const Color.fromARGB(255, 8, 33, 53),
                              Colors.blue,
                              const Color.fromARGB(255, 14, 63, 104)
                            ],

                            /// Optional, The color collections
                            strokeWidth: 2,

                            /// Optional, The stroke of the line, only applicable to widget which contains line
                            backgroundColor: Colors.transparent,

                            /// Optional, Background of the widget
                            pathBackgroundColor: Colors.transparent

                            /// Optional, the stroke backgroundColor
                            ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        focusBorderColor: Colors.blue.shade500,
                        errorBorderColor: Colors.red,
                        fillColor: Colors.white12,
                        textColor: Colors.white,
                        hintText: 'Type your message...',
                        hintColor: Colors.lightBlue.shade300,
                        controller: chatController.userMessage,
                        cursorColor: Colors.blue.shade300,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send,
                          color: chatController.isLoading.value
                              ? Colors.grey
                              : Colors.blue),
                      onPressed:
                          chatController.isLoading.value ? null : _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
      return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('Room: ${widget.roomName}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white), // Icon color
              onPressed: () {
                showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      100, 50, 0, 0), // Adjust position if needed
                  items: [
                    PopupMenuItem(
                      value: 'tts',
                      child: Text('TTS Settings',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    PopupMenuItem(
                      value: 'memory',
                      child: Text('Memory Settings',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    PopupMenuItem(
                      value: 'prompt',
                      child: Text('Prompt Settings',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    PopupMenuItem(
                      value: 'AI',
                      child: Text('AI Settings',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    PopupMenuItem(
                      value: 'Live Chat',
                      child: Text('Live Chat',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                  color: Colors.grey[900], // Dropdown background color
                ).then((value) {
                  if (value != null) {
                    if (value == 'tts') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TtsSettingsScreen(
                                ttsController: ttsController,
                                isAnimationAllowed: widget.isAnimationAllowed,
                              )));
                    } else if (value == 'memory') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemoryManagementScreen(
                              isAnimationAllowed: widget.isAnimationAllowed)));
                    } else if (value == 'prompt') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PromptSettingsScreen(
                              roomName: widget.roomName,
                              isAnimationAllowed: widget.isAnimationAllowed)));
                    } else if (value == 'AI') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                              isAnimationAllowed: widget.isAnimationAllowed)));
                    } else if (value == 'Live Chat') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LiveChat(
                              roomName: widget.roomName,
                              sttController: sttController,
                              ttsController: ttsController,
                              isAnimationAllowed: widget.isAnimationAllowed)));
                    }
                  }
                });
              },
            ),
          ],
        ),
        drawer: RoomDrawer(
          rooms: chatDatabaseController.rooms,
          currentRoom: widget.roomName,
          onNavigateToRoom: _navigateToRoom,
          onAddRoom: _addRoom,
          deleteRoom: _deleteRoom,
          updateRoomName: _updateRoomName,
        ),
        body: widget.isAnimationAllowed? DigitalCityAnimation(
          child: column,
        ): column
      );
    });
  }

  Future<void> _addRoom() async {
    await chatController.addRoom(context, chatDatabaseController.rooms, widget.isAnimationAllowed);
  }

  Future<void> _deleteRoom(String roomName) async {
    // Dispose controllers before navigating
    if (widget.roomName == roomName) {
      Get.delete<SttController>();
      Get.delete<TtsController>();
    }
    await chatController.deleteRoom(context, roomName, widget.roomName);
  }

  Future<void> _updateRoomName(String oldName) async {
    await chatController.updateRoomName(
        context, oldName, chatDatabaseController.rooms, widget.isAnimationAllowed);
  }
}
