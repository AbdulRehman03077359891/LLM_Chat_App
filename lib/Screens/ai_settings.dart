import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Animation/background_animation.dart';
import 'package:llama_chat_app/Widgets/e1_button.dart';
import 'package:llama_chat_app/Widgets/text_field_widget.dart';
import 'package:llama_chat_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final bool isAnimationAllowed;
  const SettingsScreen({super.key, required this.isAnimationAllowed});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _maxTokensController = TextEditingController();
  double _temperature = 0.7;
  late bool _isAnimationAllowed;

  @override
  void initState() {
    super.initState();
    _isAnimationAllowed = widget.isAnimationAllowed; // Initialize toggle state
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serverUrlController.text = prefs.getString('serverUrl') ?? '';
      _maxTokensController.text =
          prefs.getInt('maxTokens')?.toString() ?? '500';
      _temperature = prefs.getDouble('temperature') ?? 0.7;
      _isAnimationAllowed = prefs.getBool('isAnimationAllowed') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('serverUrl', _serverUrlController.text);
    await prefs.setInt('maxTokens', int.parse(_maxTokensController.text));
    await prefs.setDouble('temperature', _temperature);
    await prefs.setBool('isAnimationAllowed', _isAnimationAllowed);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );

    // await Future.delayed(const Duration(seconds: 1));
    // SystemNavigator.pop();
    // Reset GetX navigation and restart
    Get.reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyApp()),
      (route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    var aiThought2ndProcessAnimation = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
          ),
          TextFieldWidget(
            focusBorderColor: Colors.blue,
            errorBorderColor: Colors.red,
            fillColor: Colors.white10,
            hintColor: Colors.white,
            textColor: Colors.white,
            cursorColor: Colors.blue,
            labelColor: Colors.blue,
            controller: _serverUrlController,
            labelText: 'Server URL',
            hintText: 'Enter the Llama API server URL',
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            focusBorderColor: Colors.blue,
            errorBorderColor: Colors.red,
            fillColor: Colors.white10,
            hintColor: Colors.white,
            textColor: Colors.white,
            cursorColor: Colors.blue,
            labelColor: Colors.blue,
            controller: _maxTokensController,
            labelText: 'Max Tokens',
            hintText: 'Enter maximum tokens (e.g., 500)',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Temperature:',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  thumbColor: Colors.blue,
                  activeColor: Colors.blue,
                  value: _temperature,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: _temperature.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _temperature = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enable Animation:',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isAnimationAllowed,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _isAnimationAllowed = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
              width: 300,
              child: E1Button(
                buttonHeight: 50,
                buttonWidth: MediaQuery.of(context).size.width * .562,
                backColor: Colors.black,
                text: 'Save Settings',
                textColor: Colors.blue,
                onPressed: _saveSettings,
              )),
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
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _isAnimationAllowed
            ? AIThought2ndProcessAnimation(
                child: aiThought2ndProcessAnimation,
              )
            : aiThought2ndProcessAnimation);
  }
}
