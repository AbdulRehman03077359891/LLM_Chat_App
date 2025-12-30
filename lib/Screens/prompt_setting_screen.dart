import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatllm/Animation/background_animation.dart';
import 'package:chatllm/Controllers/local_database.dart';
import 'package:chatllm/Widgets/e1_button.dart';
import 'package:chatllm/Widgets/text_field_widget.dart';

class PromptSettingsScreen extends StatefulWidget {
  final String roomName; // Accept roomName as a parameter
  final bool isAnimationAllowed;

  const PromptSettingsScreen({super.key, required this.roomName, required this.isAnimationAllowed});

  @override
  _PromptSettingsScreenState createState() => _PromptSettingsScreenState();
}

class _PromptSettingsScreenState extends State<PromptSettingsScreen> {
  final ChatDatabaseController chatDatabaseController =
      Get.put(ChatDatabaseController());
  TextEditingController currentPrompt = TextEditingController();
  // late String currentPrompt; // To store the current prompt

  @override
  void initState() {
    super.initState();
    // Load the prompt for the specific room
    currentPrompt.text =
        chatDatabaseController.getPrompt(widget.roomName) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var padding = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Room-Specific Prompt",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    shadows: [
                      BoxShadow(
                          color: Colors.black, blurRadius: 5, spreadRadius: 5)
                    ]),
              ),
              SizedBox(height: 10),
              // Bind the TextField to the room-specific prompt
              TextFieldWidget(
                focusBorderColor: Colors.blue,
                errorBorderColor: Colors.red,
                fillColor: Colors.white10,
                hintColor: Colors.white,
                textColor: Colors.white,
                cursorColor: Colors.blue,
                controller: currentPrompt,
                hintText: "Set a prompt for this room...",
                lines: 5,
              ),
              SizedBox(height: 20),
              E1Button(
                buttonHeight: 50,
                buttonWidth: MediaQuery.of(context).size.width*.562,
                backColor: Colors.black,
                text: "Save Prompt",
                textColor: Colors.blue,
                onPressed: () {
                  chatDatabaseController.savePrompt(
                      widget.roomName, currentPrompt.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Prompt Updated for ${widget.roomName}')),
                  );
                },
              ),
            ],
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
        title: Text(
          'Prompt Settings for ${widget.roomName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: widget.isAnimationAllowed? Particle3rdDNAAnimation(
        child: padding,
      ):padding
    );
  }
}
