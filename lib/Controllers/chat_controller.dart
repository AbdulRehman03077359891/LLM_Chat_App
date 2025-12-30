import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatllm/Controllers/local_database.dart';
import 'package:chatllm/Controllers/stt_controller.dart';
import 'package:chatllm/Controllers/tts_controller.dart';
import 'package:chatllm/Screens/chat_screen.dart';
import 'package:chatllm/Screens/room_selection_screen.dart';
import 'package:chatllm/llama_api.dart';

class ChatController extends GetxController {
  final LlamaApi llamaApi;
  RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  RxBool isLoading = false.obs;
  TextEditingController userMessage = TextEditingController();
  final RxString globalPrompt = ''.obs; // To store the global prompt
  final RxMap<String, String> roomPrompts =
      <String, String>{}.obs; // To store room-specific prompts
  ChatDatabaseController chatDatabaseController =
      Get.put(ChatDatabaseController());

  ChatController({required this.llamaApi});

  // Set a specific prompt for a room
  Future<void> setPrompt(String roomName, String prompt) async {
    await chatDatabaseController.savePrompt(roomName, prompt);
  }

// Retrieve the prompt for a specific room
  String? getRoomPrompt(String roomName) {
    return chatDatabaseController.getPrompt(roomName);
  }

// Set a global prompt (this could be saved in a different table or as a shared value)
  Future<void> setGlobalPrompt(String prompt) async {
    // Define how you want to store or handle global prompts
    // For example, storing it in a singleton or a settings table.
  }

// Retrieve the global prompt (this could be from a settings table or global variable)
// String? getGlobalPrompt() {
  // Return the global prompt from where it's stored
// }

  /// Load chat history from the local database
  Future<List<Map<String, String>>> loadMessages(String roomName) async {
    return await chatDatabaseController.getMessages(roomName);
  }

  /// Save a message to the database
  Future<void> saveMessage(String roomName, String role, String content) async {
    await chatDatabaseController.saveMessage(roomName, role, content);
  }

  /// Generate a response from the Llama API
  Future<String> generateResponse(List<Map<String, String>> messages) async {
    return await llamaApi.generateResponse(messages.map((msg) => msg).toList());
  }

  /// Delete all messages in a specific room
  Future<void> deleteMessages(String roomName) async {
    await chatDatabaseController.deleteMessages(roomName);
  }

  Future<void> rememberConversation(
    String roomName,
  ) async {
    isLoading.value = true;

    if (userMessage.text.isNotEmpty &&
        _containsMemoryRequest(userMessage.text)) {
      // Retrieve chat history for the room
      final chatHistory = await chatDatabaseController.getMessages(roomName);

      // Append instruction as an additional entry
      final enhancedHistory = [
        {
          'role': 'system',
          'content': '''
          You are Eve de Muslim, an AI assistant. Please analyze the conversation history below and create a detailed, actionable memory summary. The memory should include:

          - Specific details about the user's preferences, requests, or instructions.
          - Any names, events, or concepts explicitly mentioned by the user.
          - Any other important context relevant to improving future interactions.

          Avoid generic descriptions. Create concise, detailed, and structured memory points and make it shorter.

          Conversation History:

          ${chatHistory.map((msg) => '${msg['role']}: ${msg['content']}').join('\n')}
        '''
        }
      ];

      messages.add({'role': 'user', 'content': userMessage.text});
      userMessage.clear();

      try {
        // Generate a summary using the Llama model
        final summary = await generateResponse(enhancedHistory);

        // Save the summary to the memory table
        await chatDatabaseController.saveMemory(summary);

        // Update UI with the assistant's message
        messages.add({
          'role': 'assistant',
          'content': 'Your memory has been successfully saved!'
        });
        userMessage.clear();
      } catch (e) {
        // Update UI with the assistant's message
        messages.add(
            {'role': 'assistant', 'content': 'Error: Unable to save memory.'});
        userMessage.clear();
      } finally {
        isLoading.value = false;
      }
    } else {
      await sendMessage(roomName);
    }
  }

// Helper function to check for memory requests
  bool _containsMemoryRequest(String message) {
    // Define memory request patterns (you can extend this list)
    const memoryRequestKeywords = [
      'remember this',
      'store this information',
      'save this memory',
      'keep this in mind'
    ];

    // Check if the message contains any memory request keyword (case-insensitive)
    for (final keyword in memoryRequestKeywords) {
      if (message.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  Future<void> sendMessage(
    String roomName,
  ) async {
    final trimmedUserMessage = userMessage.text.trim();
    if (trimmedUserMessage.isEmpty) return;

    final roomPrompt = chatDatabaseController.getPrompt(roomName);

    // Convert memory descriptions into message format
    final memoryMessages = chatDatabaseController.memories
        .map((memory) => {'role': 'memory', 'content': memory})
        .toList();

    // Add system instructions to make memory contextual
    final memoryContextInstruction = {
      'role': 'system',
      'content': memoryMessages.map((m) => m['content']).join(' ')
    };

    // Include the room's prompt, if available
    final roomPromptInstruction = roomPrompt != null
        ? {
            'role': 'system',
            'content':
                roomPrompt
          }
        : null;

    messages.add({'role': 'user', 'content': trimmedUserMessage});
    userMessage.clear();

    await saveMessage(roomName, 'user', trimmedUserMessage);

    try {
      // Combine memory messages, room prompt, and the current chat messages
      final conversationContext = [
        if (roomPromptInstruction != null) roomPromptInstruction,
        memoryContextInstruction,
        ...messages
      ];

      // Variable to collect streamed response chunks
      final StringBuffer assistantResponse = StringBuffer();

      // Generate response using streaming
      await llamaApi.generateStreamedResponse(conversationContext, (chunk) {
        // Append chunk to the response buffer
        assistantResponse.write(chunk);

        // Update the last assistant message in real-time (for UI feedback)
        if (messages.isNotEmpty && messages.last['role'] == 'assistant') {
          messages.last['content'] = assistantResponse.toString();
        } else {
          messages.add(
              {'role': 'assistant', 'content': assistantResponse.toString()});
        }

        // Notify UI about the update (if using reactive state management)
        messages.refresh();
      });

      // Save the complete assistant's message to chat history
      await saveMessage(roomName, 'assistant', assistantResponse.toString());

      // // Generate response using combined context
      // final assistantMessage = await generateResponse(conversationContext);

      // // Update UI with the assistant's message
      // messages.add({'role': 'assistant', 'content': assistantMessage});

      // // Save the assistant's message to chat history
      // await saveMessage(roomName, 'assistant', assistantMessage);
    } catch (e) {
      // Handle errors
      messages.add({
        'role': 'assistant',
        'content': 'Error: Unable to get a response from the server.'
      });
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRoom(
      BuildContext context, String currentRoom, String roomName, bool isAnimationAllowed) {
    if (roomName != currentRoom) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(roomName: roomName, isAnimationAllowed: isAnimationAllowed,),
        ),
      );
    }
  }

  Future<void> addRoom(BuildContext context, List<String> rooms, bool isAnimationAllowed) async {
    final TextEditingController roomNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Room'),
          content: TextField(
            controller: roomNameController,
            decoration: InputDecoration(hintText: 'Enter room name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newRoom = roomNameController.text.trim();
                if (newRoom.isNotEmpty && !rooms.contains(newRoom)) {
                  await chatDatabaseController.saveRoom(newRoom);
                  // Dispose controllers before navigating
                  await Get.delete<SttController>();
                  await Get.delete<TtsController>();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomName: newRoom, isAnimationAllowed: isAnimationAllowed,),
                    ),
                  );
                } else {
                  _showErrorDialog(
                      context, 'Room name is either empty or already exists.');
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteRoom(
      BuildContext context, String roomName, String currentRoom) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.black87,shadowColor: Colors.blue,
          title: Text('Delete Room',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          content: Text(
              'Are you sure you want to delete "$roomName"? This action cannot be undone.',style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () async {
                // Handle delete
                if (roomName == currentRoom) {
                  Navigator.of(context).pop(true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomSelectionScreen(),
                    ),
                  );
                } else {
                  Navigator.of(context).pop(true);
                }
                await chatDatabaseController.deleteRoom(roomName);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      await deleteMessages(roomName);
    }
  }

  Future<void> updateRoomName(
    BuildContext context,
    String oldName,
    List<String> rooms,
    bool isAnimationAllowed,
  ) async {
    final TextEditingController roomNameController =
        TextEditingController(text: oldName);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.black87,shadowColor: Colors.blue,
          title: Text('Update Room Name',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
          content: TextField(
            cursorColor: Colors.blue,
            style: TextStyle(color: Colors.white),
            controller: roomNameController,
            decoration: InputDecoration(hintText: 'Enter new room name',fillColor: Colors.white12,hintStyle: TextStyle(color: Colors.blue),border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,))),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () async {
                final newRoom = roomNameController.text.trim();
                if (newRoom.isNotEmpty && !rooms.contains(newRoom)) {
                  // Update the room name in the rooms table
                  await chatDatabaseController.updateRoomName(oldName, newRoom);

                  // Update the room name in the chat_history table
                  await chatDatabaseController.updateChatHistoryRoomName(
                      oldName, newRoom);

                  // Reload rooms to reflect the update
                  await

                      // Navigate to the updated room
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomName: newRoom, isAnimationAllowed: isAnimationAllowed,),
                    ),
                  );
                } else {
                  _showErrorDialog(
                      context, 'Room name is either empty or already exists.');
                }
              },
              child: Text('Update',style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
