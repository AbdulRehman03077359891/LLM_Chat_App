import 'package:flutter/material.dart';

class AnimatedDialog extends StatelessWidget {
  final Widget child;

  const AnimatedDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ModalRoute.of(context)!.animation!,
      builder: (context, child) {
        // Slide animation
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0), // Start from below the screen
            end: Offset.zero, // End at the center
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
      child: child,
    );
  }
}