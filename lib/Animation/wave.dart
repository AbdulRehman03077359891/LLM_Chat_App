import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatllm/Controllers/tts_controller.dart';

class AudioVisualizer extends StatelessWidget {
  final TtsController ttsController;

  const AudioVisualizer({Key? key, required this.ttsController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double amplitude = ttsController.amplitude.value;

      return Center(
        child: CustomPaint(
          painter: WaveformPainter(amplitude),
          size: Size(MediaQuery.of(context).size.width, 200), // Adjust size as needed
        ),
      );
    });
  }
}

class WaveformPainter extends CustomPainter {
  final double amplitude;

  WaveformPainter(this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    double midHeight = size.height / 2;
    double waveWidth = size.width / 50; // Adjust wave frequency

    for (double i = 0; i < size.width; i += waveWidth) {
      double y = midHeight +
          amplitude * midHeight * 0.8 * 
           sin(2 * pi * i / size.width); // Corrected usage of sin and pi
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw continuously
  }
}
