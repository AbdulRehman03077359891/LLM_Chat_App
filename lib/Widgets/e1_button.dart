import 'package:flutter/material.dart';
import 'dart:math';

class E1Button extends StatefulWidget {
  final Color backColor;
  final Color textColor;
  final String text;
  final double size;
  final VoidCallback? onPressed;
  final Color? shadowColor;
  final double elevation;
  final double buttonWidth;
  final double buttonHeight;

  const E1Button({
    super.key,
    required this.backColor,
    required this.text,
    required this.textColor,
    this.onPressed,
    this.shadowColor,
    this.size = 16.0, // Default font size
    this.elevation = 10.0, // Default elevation
    required this.buttonWidth,
    required this.buttonHeight,
  });

  @override
  _E1ButtonState createState() => _E1ButtonState();
}

class _E1ButtonState extends State<E1Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  
  late double _buttonWidth;
  late double _buttonHeight;

  @override
  void initState() {
    super.initState();
    
  _buttonWidth =  widget.buttonWidth; //200.0; // Width of the button
  _buttonHeight = widget.buttonHeight;   //60.0; // Height of the button
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Continuous animation for rotation

    // Continuous animation from 0.0 to 2 * pi (1 full rotation)
    _angleAnimation = Tween<double>(begin: 0.0, end: 1 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: _buttonWidth,
        height: _buttonHeight,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Stack(
            children: [
              // Button itself
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: widget.backColor,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: widget.shadowColor ?? Colors.blue.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.onPressed == null ? Colors.grey : widget.textColor,
                      fontSize: widget.size,
                    ),
                  ),
                ),
              ),
              // Particle 1
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _buildParticle(_angleAnimation.value);
                },
              ),
              // Particle 2 (180 degrees apart)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _buildParticle(_angleAnimation.value + pi); // 180 degrees apart
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(double angle) {
    // Use button's width and height to calculate border's perimeter for positioning
    final double centerX = _buttonWidth / 2.11;
    final double centerY = _buttonHeight / 3;

    // Particle position calculation (move on the border)
    final double x = centerX + (centerX * cos(angle));
    final double y = centerY + (centerY * sin(angle));

    return Positioned(
      left: 0 + x, // Offset by 100 to center the button
      top: 0 + y,   // Offset by 50 to center the button
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.blue, // Particle color
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
