import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Controllers/chat_controller.dart';
import 'package:llama_chat_app/Controllers/local_database.dart';
import 'package:llama_chat_app/Controllers/tts_controller.dart';
import 'package:llama_chat_app/llama_api.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart'; // Add permission_handler package

class SttController extends GetxController {
  final stt.SpeechToText speech = stt.SpeechToText();
  RxBool isListening = false.obs;
  final ChatController chatController =
      Get.put(ChatController(llamaApi: LlamaApi('http://127.0.0.1:8080')));
  final LlamaApi llamaApi;
  late final TtsController ttsController;  // Adding TtsController as dependency
  ChatDatabaseController chatDatabaseController = Get.put(ChatDatabaseController());
  Timer? inactivityTimer;

  // Constructor now expects TtsController as well
  SttController({required this.llamaApi,});

  // Set the TtsController after initialization
  void setTtsController(TtsController tts) {
    ttsController = tts;
  }


  // Start listening for user speech
  Future<void> startListening() async {
    debugPrint("Attempting to start listening...");
    // Prevent listening if TTS is speaking
    if (isListening.value || ttsController.isSpeaking.value) {
      debugPrint(
          "Cannot start listening. Either already listening or TTS is speaking.");
      return;
    }
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      bool available = await speech.initialize(finalTimeout: Duration(minutes: 1));
      if (available) {
        isListening.value = true;
        debugPrint("Speech recognition started.");

        // Start the inactivity timer
        _startInactivityTimer();

        speech.listen(onResult: (result) {
          if (result.finalResult) {
            debugPrint("STT detected speech: ${result.recognizedWords}");
            sendMessage(result.recognizedWords);
                        _restartInactivityTimer(); // Restart timer on user speech
          }
        },
        listenFor: Duration(seconds: 60), // Adjust for longer sessions
      );
      } else {
        debugPrint("Speech recognition is unavailable.");
        isListening.value = false;
      }
    } else {
      debugPrint("Microphone permission not granted.");
      isListening.value = false;
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    if (!isListening.value) {
      debugPrint("Not currently listening, skipping stop.");
      return;
    }
    debugPrint("Stopping listening...");
    isListening.value = false;
    await speech.stop();
          _cancelInactivityTimer(); // Cancel the inactivity timer
    debugPrint("Listening stopped.");
  }

  // Restart listening for user speech
  Future<void> restartListening() async {
    debugPrint("Restarting speech recognition...");
    await stopListening();
    await startListening();
  }

  // Starts the inactivity timer
  void _startInactivityTimer() {
    _cancelInactivityTimer(); // Cancel any existing timer
    inactivityTimer = Timer(Duration(seconds: 10), () {
      if (isListening.value) {
        debugPrint("Inactivity detected. Restarting listening...");
        restartListening();
      }
    });
  }

  // Restarts the inactivity timer
  void _restartInactivityTimer() {
    debugPrint("Restarting inactivity timer...");
    _startInactivityTimer();
  }

  // Cancels the inactivity timer
  void _cancelInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer = null;
  }


  // Send user message and get response from AI
  Future<void> sendMessage(String userMessage) async {
    // Stop listening while generating a response
    await stopListening();

    chatController.messages.add({'role': 'user', 'content': userMessage});
    // Convert memory descriptions into message format
    final memoryMessages = chatDatabaseController.memories
        .map((memory) => {'role': 'memory', 'content': memory})
        .toList();
    
    // Add system instructions to make memory contextual
    final memoryContextInstruction = {
      'role': 'system',
      'content': '''
You are Eve de Muslim, an AI assistant. The following memory entries are retrieved to assist you in this conversation. Use these entries to provide accurate, helpful, and contextual responses:
${memoryMessages.map((m) => m['content']).join('\n')}
'''
    };

    try {
      // Combine memory messages, room prompt, and the current chat messages
      final conversationContext = [
                memoryContextInstruction,
        ...chatController.messages
      ];

      // Call your AI system and get response
      final assistantMessage =
          await llamaApi.generateResponse(conversationContext);

      // Add assistant's message to chat
      chatController.messages
          .add({'role': 'assistant', 'content': assistantMessage});
      debugPrint("AI Response: $assistantMessage");

      // Convert assistant's response to speech
      await ttsController.speakText(assistantMessage,
          onComplete: startListening);
    } catch (e) {
      debugPrint("Error in AI response: $e");
      await startListening();
    } finally {
      // Restart listening after the response is generated
      debugPrint("TTS finished speaking. Restarting STT...");
      await startListening();
    }
  }
}
