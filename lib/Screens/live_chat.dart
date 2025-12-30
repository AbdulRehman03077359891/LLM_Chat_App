import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatllm/Animation/background_animation.dart';
import 'package:chatllm/Controllers/stt_controller.dart';
import 'package:chatllm/Controllers/tts_controller.dart';

class LiveChat extends StatefulWidget {
  final String roomName;
  final SttController sttController;
  final TtsController ttsController;
  final bool isAnimationAllowed;

  const LiveChat(
      {super.key,
      required this.roomName,
      required this.sttController,
      required this.ttsController, required this.isAnimationAllowed});

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  @override
  void initState() {
    super.initState();
    // Start listening when the screen is opened
    widget.sttController.startListening();
    widget.ttsController.setIsLive(true);
  }

  @override
  void dispose() {
    // Stop listening and speaking before disposing the controllers
    widget.sttController.stopListening();
    widget.ttsController.stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            'Voice Chat - Room: ${widget.roomName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                color: Colors.black,
              ),
            ),
            // Animation reacts to TTS progress
            TTS2ndReactiveAnimation(
              frequency: widget.ttsController.amplitude,
            ),

            // Main content
            Column(
              children: [
                // Message Display Area
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount:
                        widget.sttController.chatController.messages.length,
                    itemBuilder: (context, index) {
                      final reversedIndex =
                          widget.sttController.chatController.messages.length -
                              1 -
                              index;
                      final message = widget
                          .sttController.chatController.messages[reversedIndex];
                      final isUser = message['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: isUser
                                ? Border(
                                    bottom: BorderSide(color: Colors.white54),
                                    left: BorderSide(color: Colors.white54),
                                    top: BorderSide(color: Colors.white54))
                                : Border(
                                    bottom: BorderSide(color: Colors.white54),
                                    right: BorderSide(color: Colors.white54),
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Voice Control Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(color: Colors.white10,shape: BeveledRectangleBorder(side: BorderSide(color: Colors.white12),borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(10)))),
                    child: Column(
                      children: [
                        Text(
                          widget.sttController.isListening.value
                              ? "Listening... Speak now"
                              : "Tap the mic to start talking",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        IconButton(
                          iconSize: 48,
                          icon: Icon(
                            widget.sttController.isListening.value
                                ? Icons.mic
                                : Icons.mic_none,
                            color: widget.sttController.isListening.value
                                ? Colors.red
                                : Colors.white,
                          ),
                          onPressed: () async {
                            if (widget.sttController.isListening.value) {
                              await widget.sttController.stopListening();
                            } else {
                              await widget.sttController.startListening();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
