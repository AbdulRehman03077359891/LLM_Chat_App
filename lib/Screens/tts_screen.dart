import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatllm/Animation/background_animation.dart';
import 'package:chatllm/Controllers/tts_controller.dart';

class TtsSettingsScreen extends StatelessWidget {
  // final TtsController ttsController = Get.put(TtsController(sttController: null));
  final TtsController ttsController;
  final bool isAnimationAllowed;

  const TtsSettingsScreen({super.key, required this.ttsController, required this.isAnimationAllowed});

  @override
  Widget build(BuildContext context) {
    var padding = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: Colors.black38,
              shadowColor: Colors.white12,
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.white30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Voice",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue, shadows: [
                            BoxShadow(
                                color: Colors.black, blurRadius: 5, spreadRadius: 5)
                          ]),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return DropdownButton<String>(
                        focusColor: Colors.blue,
                        dropdownColor: Colors.white10,
                        value: ttsController.selectedVoice.value,
                        items: ttsController.availableVoices.map((voice) {
                          return DropdownMenuItem(
                            value: voice,
                            child: Text(voice, style: TextStyle(color: Colors.white),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) ttsController.changeVoice(value);
                        },
                        hint: Text("Select a voice",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      );
                    }),
                    SizedBox(height: 20),
                    Text(
                      "Speech Rate",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue, shadows: [
                            BoxShadow(
                                color: Colors.black, blurRadius: 5, spreadRadius: 5)
                          ]),
                    ),
                    Obx(() {
                      return Slider(thumbColor: Colors.blue,
                      activeColor: Colors.blue,
                        value: ttsController.speechRate.value,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: ttsController.speechRate.value.toStringAsFixed(1),
                        onChanged: (value) {
                          ttsController.updateSpeechRate(value);
                        },
                      );
                    }),
                    SizedBox(height: 20),
                    Text(
                      "Speech Pitch",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue, shadows: [
                            BoxShadow(
                                color: Colors.black, blurRadius: 5, spreadRadius: 5)
                          ]),
                    ),
                    Obx(() {
                      return Slider(thumbColor: Colors.blue,
                      activeColor: Colors.blue,
                        value: ttsController.speechPitch.value,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: ttsController.speechPitch.value.toStringAsFixed(1),
                        onChanged: (value) {
                          ttsController.updateSpeechPitch(value);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text('TTS Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isAnimationAllowed? DNAParticleAnimation(
        child: padding,
      ): padding
    );
  }
}
