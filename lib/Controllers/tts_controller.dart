import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Controllers/stt_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:llama_chat_app/llama_api.dart';

class TtsController extends GetxController {
  final FlutterTts _flutterTts = FlutterTts();
  var availableVoices = <String>[].obs;
  var selectedVoice = Rxn<String>();
  var isSpeaking = false.obs;
  bool isLive = false;
  final RxDouble amplitude = 0.0.obs; // For wave height
  Timer? _amplitudeTimer;

  var speechRate = 0.5.obs; // Speech rate default
  var speechPitch = 1.0.obs; // Speech pitch default

  VoidCallback? onTtsComplete; // Callback to trigger after TTS completes
  final SttController sttController; // Accepting SttController via constructor

  // Constructor now expects SttController
  TtsController({required this.sttController});
  
  @override
  void onInit() {
    super.onInit();
    _configureTts();
    _loadSettings();  // Load saved settings when the controller is initialized
    _flutterTts.setCompletionHandler(_onSpeechComplete);

    // Set initial values for speech rate and pitch
    _flutterTts.setSpeechRate(speechRate.value);
    _flutterTts.setPitch(speechPitch.value);
  }

  setIsLive(value){
    isLive = value;
  }

  Future<void> _configureTts() async {
    try {
      // Set default configurations
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.3); // Emotional pitch
      await _flutterTts.setSpeechRate(0.5); // Calm rate
      await _flutterTts.setVolume(1.0);

      // Fetch available voices
      final voices = await _flutterTts.getVoices;
      final voicesList = voices
          .where((voice) =>
              voice is Map<Object?, Object?> && voice.containsKey('name'))
          .map<String>((voice) {
        final map = Map<String, dynamic>.from(voice as Map<Object?, Object?>);
        return map['name'] as String;
      }).toList();

      availableVoices.assignAll(voicesList);

      // Set default voice
      if (availableVoices.isNotEmpty && selectedVoice.value == null) {
        selectedVoice.value = availableVoices.first;
        await _flutterTts
            .setVoice({'name': selectedVoice.value!, 'locale': 'en-US'});
            _saveSettings();
      }
    } catch (e) {
      debugPrint("Error configuring TTS: $e");
    }
  }

  void _onSpeechComplete(){
    isSpeaking.value = false;
    debugPrint("TTS finished speaking.");
  _stopAmplitudeSimulation(); // Stop the animation when speech is complete

    // Start listening again after TTS finishes speaking
    if (!sttController.isListening.value && isLive) {
      sttController.startListening();
    }
  }

  Future<void> changeVoice(String voiceName) async {
    try {
      selectedVoice.value = voiceName;
      await _flutterTts.setVoice({'name': voiceName, 'locale': 'en-US'});
    } catch (e) {
      debugPrint("Error changing voice: $e");
    }
  }

  Future<void> speakText(String text, {VoidCallback? onComplete}) async {
    if (text.isNotEmpty) {
      try {
        isSpeaking.value = true;
        debugPrint("TTS is speaking...");
        _startAmplitudeSimulation(text); // Start amplitude simulation

        await _flutterTts.speak(text);
      } catch (e) {
        debugPrint("Error speaking text: $e");
        isSpeaking.value = false;
      _stopAmplitudeSimulation(); // Ensure simulation stops on error
      }
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      isSpeaking.value = false;
    _stopAmplitudeSimulation();
    } catch (e) {
      debugPrint("Error stopping TTS: $e");
    }
  }

  void _startAmplitudeSimulation(String text) {
  _amplitudeTimer?.cancel();
  final words = text.split(' '); // Split text into words
  int wordIndex = 0;
  // Calculate the total duration of speech in seconds
  double totalDuration = (words.length / speechRate.value) * 60; // Duration in seconds
  double timePerWord = totalDuration / words.length; // Duration per word

  // Start the amplitude simulation
  _amplitudeTimer = Timer.periodic(Duration(milliseconds: timePerWord.toInt()), (timer) {
    // if (wordIndex >= words.length* words.length) {
    //   _stopAmplitudeSimulation();
    //   return;
    // }

    final word = words[wordIndex % words.length];
    final amplitudeValue = _calculateAmplitude(word); // Calculate amplitude based on word
    amplitude.value = amplitudeValue;
  debugPrint("Amplitude updated: $amplitudeValue"); // Add debug print to see updates

    wordIndex++; // Move to the next word
  });
}

double _calculateAmplitude(String word) {
  final vowelCount = word.replaceAll(RegExp(r'[^aeiouAEIOU]'), '').length;
  final wordLength = word.length;

  // Higher amplitude for more vowels and longer words
  return (vowelCount / wordLength).clamp(0.1, 1.0);
}


  void _stopAmplitudeSimulation() {
    _amplitudeTimer?.cancel();
    amplitude.value = 0.0;
  }


  void updateSpeechRate(double rate) async {
  speechRate.value = rate;
  await _flutterTts.setSpeechRate(rate); // Set the rate on FlutterTts
  _saveSettings();
}

void updateSpeechPitch(double pitch) async {
  speechPitch.value = pitch;
  await _flutterTts.setPitch(pitch); // Set the pitch on FlutterTts
  _saveSettings();
}

  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVoice', selectedVoice.value ?? '');
    await prefs.setDouble('speechRate', speechRate.value);
    await prefs.setDouble('speechPitch', speechPitch.value);
  }

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedVoice.value = prefs.getString('selectedVoice') ?? availableVoices.first;
    speechRate.value = prefs.getDouble('speechRate') ?? 0.5;
    speechPitch.value = prefs.getDouble('speechPitch') ?? 1.0;

    // Apply the loaded settings to the FlutterTts instance
    await _flutterTts.setSpeechRate(speechRate.value);
    await _flutterTts.setPitch(speechPitch.value);
  }
}
