import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


/////////////////////////////////////////////////////////////////////////////////////
class BackgroundGradientAnimation extends StatefulWidget {
  final Widget child;

  const BackgroundGradientAnimation({super.key, required this.child});

  @override
  State<BackgroundGradientAnimation> createState() =>
      _BackgroundGradientAnimationState();
}

class _BackgroundGradientAnimationState
    extends State<BackgroundGradientAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _animation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _animation.value,
              end: Alignment.centerRight,
              colors: const [
                Color.fromARGB(255, 54, 54, 54),
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class PulsatingBackgroundAnimation extends StatefulWidget {
  final Widget child;

  const PulsatingBackgroundAnimation({super.key, required this.child});

  @override
  State<PulsatingBackgroundAnimation> createState() =>
      _PulsatingBackgroundAnimationState();
}

class _PulsatingBackgroundAnimationState
    extends State<PulsatingBackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: _animation.value,
              colors: const [
                Colors.blueAccent,
                Colors.black,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Rotating Gradient Animation/////////////////////////////////////////////////////////////////////////////////////
class RotatingGradientAnimation extends StatefulWidget {
  final Widget child;

  const RotatingGradientAnimation({super.key, required this.child});

  @override
  State<RotatingGradientAnimation> createState() =>
      _RotatingGradientAnimationState();
}

class _RotatingGradientAnimationState extends State<RotatingGradientAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.purple,
                Colors.red,
              ],
              stops: [
                _controller.value,
                (_controller.value + 0.25) % 1.0,
                (_controller.value + 0.5) % 1.0,
                (_controller.value + 0.75) % 1.0,
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Color Cycling Gradient Animation/////////////////////////////////////////////////////////////////////////////////////
class ColorCyclingGradientAnimation extends StatefulWidget {
  final Widget child;

  const ColorCyclingGradientAnimation({super.key, required this.child});

  @override
  State<ColorCyclingGradientAnimation> createState() =>
      _ColorCyclingGradientAnimationState();
}

class _ColorCyclingGradientAnimationState
    extends State<ColorCyclingGradientAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color.fromARGB(255, 0, 0, 0),
                    const Color.fromARGB(255, 80, 80, 80), _controller.value)!,
                Color.lerp(const Color.fromARGB(255, 40, 40, 40),
                    const Color.fromARGB(255, 60, 60, 60), _controller.value)!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class FuturisticGlowAnimation extends StatefulWidget {
  final Widget child;

  const FuturisticGlowAnimation({super.key, required this.child});

  @override
  State<FuturisticGlowAnimation> createState() =>
      _FuturisticGlowAnimationState();
}

class _FuturisticGlowAnimationState extends State<FuturisticGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: _animation.value,
              colors: const [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 50.0 * _animation.value,
                spreadRadius: 10.0 * _animation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}



// Futuristic Rotating Matrix Animation/////////////////////////////////////////////////////////////////////////////////////
class FuturisticMatrixAnimation extends StatefulWidget {
  final Widget child;

  const FuturisticMatrixAnimation({super.key, required this.child});

  @override
  State<FuturisticMatrixAnimation> createState() =>
      _FuturisticMatrixAnimationState();
}

class _FuturisticMatrixAnimationState extends State<FuturisticMatrixAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + _controller.value * 2.0,
                -1.0 + _controller.value * 2.0,
              ),
              end: Alignment(
                1.0 - _controller.value * 2.0,
                1.0 - _controller.value * 2.0,
              ),
              colors: const [
                Color(0xFF232526),
                Color(0xFF414345),
              ],
            ),
            backgroundBlendMode: BlendMode.overlay,
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent,
                blurRadius: 30.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}



// Futuristic Particle Animation/////////////////////////////////////////////////////////////////////////////////////
class FuturisticParticleAnimation extends StatefulWidget {
  final Widget child;

  const FuturisticParticleAnimation({super.key, required this.child});

  @override
  State<FuturisticParticleAnimation> createState() =>
      _FuturisticParticleAnimationState();
}

class _FuturisticParticleAnimationState
    extends State<FuturisticParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final position = Offset(
              (_controller.value * 100 + index * 10) %
                  MediaQuery.of(context).size.width,
              (index * 20) % MediaQuery.of(context).size.height,
            );
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


// DNA Particle Animation/////////////////////////////////////////////////////////////////////////////////////
class DNAParticleAnimation extends StatefulWidget {
  final Widget child;

  const DNAParticleAnimation({super.key, required this.child});

  @override
  State<DNAParticleAnimation> createState() => _DNAParticleAnimationState();
}

class _DNAParticleAnimationState extends State<DNAParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // Use EaseInOut for smoother animations
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Set the background to black
      body: Stack(
        children: [
          // Particle Animation Layer
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: List.generate(40, (index) {
                  final progress = (_animation.value + index / 40) % 1.0;
                  final x = sin(progress * 2 * pi) * 100 + MediaQuery.of(context).size.width / 2;
                  final y = progress * MediaQuery.of(context).size.height;

                  return Positioned(
                    left: x,
                    top: y,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          // Child Widget in the foreground
          Center(child: widget.child), // Center the child widget on top
        ],
      ),
    );
  }
}



// DNA Particle Animation/////////////////////////////////////////////////////////////////////////////////////
class DNA2ndParticleAnimation extends StatefulWidget {
  final Widget child;

  const DNA2ndParticleAnimation({super.key, required this.child});

  @override
  State<DNA2ndParticleAnimation> createState() =>
      _DNA2ndParticleAnimationState();
}

class _DNA2ndParticleAnimationState extends State<DNA2ndParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(40, (index) {
            final progress = (_controller.value + index / 40) % 1.0;
            final angle = progress * 2 * pi;
            final radius = 100;

            final x = MediaQuery.of(context).size.width / 2 +
                radius * cos(angle) * (index % 2 == 0 ? 1 : -1);
            final y = MediaQuery.of(context).size.height / 2 +
                radius * sin(angle) +
                (index * 5 - 100);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index % 2 == 0
                        ? Colors.blueAccent
                        : Colors.purpleAccent),
              ),
            );
          }),
        );
      },
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class DNA3rdParticleAnimation extends StatefulWidget {
  final Widget child;

  const DNA3rdParticleAnimation({super.key, required this.child});

  @override
  State<DNA3rdParticleAnimation> createState() =>
      _DNA3rdParticleAnimationState();
}

class _DNA3rdParticleAnimationState extends State<DNA3rdParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        return Stack(
          children: List.generate(60, (index) {
            final progress = (_controller.value + index / 60) % 1.0;
            final angle = progress * 2 * pi;
            final helixRadius = 80.0;
            final particleOffset = index % 2 == 0 ? -1 : 1;

            // DNA-like structure coordinates
            final x = width / 2 + helixRadius * cos(angle);
            final y = height / 2 +
                particleOffset * helixRadius * sin(angle) +
                (index * 10 - 300);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index % 2 == 0
                      ? Colors.cyanAccent
                      : Colors.pinkAccent,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class ParticleDesignAnimation extends StatefulWidget {
  final Widget child;

  const ParticleDesignAnimation({super.key, required this.child});

  @override
  State<ParticleDesignAnimation> createState() =>
      _ParticleDesignAnimationState();
}

class _ParticleDesignAnimationState extends State<ParticleDesignAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ParticleDesignParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _particles = List.generate(100, (index) => ParticleDesignParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particle Animation (CustomPainter)
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ParticleDesignParticlePainter(_particles),
        ),
        // The background child
        widget.child,
      ],
    );
  }
}

class ParticleDesignParticlePainter extends CustomPainter {
  final List<ParticleDesignParticle> particles;

  ParticleDesignParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Update each particle and draw it
    for (var particle in particles) {
      particle.update(size.width, size.height);

      // Set random color for each particle
      paint.color = Color.fromARGB(
        255,
        Random().nextInt(256), // Random Red
        Random().nextInt(256), // Random Green
        Random().nextInt(256), // Random Blue
      );

      // Draw each particle as a circle
      canvas.drawCircle(Offset(particle.x, particle.y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Redraw on every frame
  }
}

class ParticleDesignParticle {
  double x = Random().nextDouble() * 300;
  double y = Random().nextDouble() * 600;
  double speedX = Random().nextDouble() * 2 - 1;
  double speedY = Random().nextDouble() * 2 - 1;

  void update(double maxWidth, double maxHeight) {
    x += speedX;
    y += speedY;

    // Keep particle within screen bounds
    if (x < 0 || x > maxWidth) speedX = -speedX;
    if (y < 0 || y > maxHeight) speedY = -speedY;
  }
}



/////////////////////////////////////////////////////////////////////////////////////
class ParticleDNAAnimation extends StatefulWidget {
  final Widget child;

  const ParticleDNAAnimation({super.key, required this.child});

  @override
  State<ParticleDNAAnimation> createState() => _ParticleDNAAnimationState();
}

class _ParticleDNAAnimationState extends State<ParticleDNAAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle1> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _particles = List.generate(100, (index) => Particle1());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particle Animation (CustomPainter)
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ParticleDNAPainter(_particles),
        ),
        // The background child
        widget.child,
      ],
    );
  }
}

class ParticleDNAPainter extends CustomPainter {
  final List<Particle1> particles;

  ParticleDNAPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Update each particle and draw it
    for (var particle in particles) {
      particle.update(size.width, size.height);

      // Set random color for each particle
      paint.color = Color.fromARGB(
        255,
        Random().nextInt(256), // Random Red
        Random().nextInt(256), // Random Green
        Random().nextInt(256), // Random Blue
      );

      // Draw each particle as a circle
      canvas.drawCircle(Offset(particle.x, particle.y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Redraw on every frame
  }
}

class Particle1 {
  double angle = Random().nextDouble() * 2 * pi;
  double radius = 100.0; // Distance from the center
  double height = 0.0; // Vertical position for the helix
  double speedAngle = Random().nextDouble() * 0.1 + 0.05; // Speed of rotation
  double speedHeight =
      Random().nextDouble() * 2 - 1; // Speed of vertical movement

  void update(double maxWidth, double maxHeight) {
    // Calculate the position along the helix using sine and cosine functions
    angle += speedAngle;
    height += speedHeight;

    // Keep particle within screen bounds
    if (height > maxHeight) height = 0; // Loop the height position
    if (height < 0) height = maxHeight;

    // Calculate the x, y coordinates for the DNA structure
    double x1 = maxWidth / 2 + radius * cos(angle);
    double y1 = maxHeight / 2 + height;

    double x2 = maxWidth / 2 - radius * cos(angle);
    double y2 = maxHeight / 2 + height;

    // Update the particle's position to follow the DNA shape
    x = (height / maxHeight > 0.5) ? x2 : x1;
    y = (height / maxHeight > 0.5) ? y2 : y1;
  }

  late double x;
  late double y;
}



/////////////////////////////////////////////////////////////////////////////////////
class Particle3rdDNAAnimation extends StatefulWidget {
  final Widget child;
  const Particle3rdDNAAnimation({super.key, required this.child});

  @override
  State<Particle3rdDNAAnimation> createState() =>
      _Particle3rdDNAAnimationState();
}

class _Particle3rdDNAAnimationState extends State<Particle3rdDNAAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<DNA3rdHelixParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Slower animation speed
    )..repeat();

    _particles = List.generate(100, (index) => DNA3rdHelixParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black background
        Container(color: Colors.black),
        // DNA animation
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: DNA3rdHelixPainter(_particles, _controller),
        ),
        // Overlay child widget
        widget.child,
      ],
    );
  }
}

class DNA3rdHelixPainter extends CustomPainter {
  final List<DNA3rdHelixParticle> particles;
  final AnimationController controller;

  DNA3rdHelixPainter(this.particles, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..color = Colors.blue // Softer glow effect
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15); // Glow blur

    final Paint corePaint = Paint()..color = Colors.blue; // Solid particle core

    for (var particle in particles) {
      particle.update(size.width, size.height);

      // Draw the glowing halo (larger circle)
      canvas.drawCircle(Offset(particle.x, particle.y), 12, glowPaint);

      // Draw the solid core (smaller circle)
      canvas.drawCircle(Offset(particle.x, particle.y), 4, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DNA3rdHelixParticle {
  double x = 0;
  double y = 0;
  double angle = Random().nextDouble() * 2 * pi;
  double height = Random().nextDouble() * 780; // Start at a random height
  double speed = 0.3; // Slower vertical movement
  double radius = 100.0; // Radius of the DNA helix
  double angleSpeed = 0.005; // Slower rotation speed

  void update(double maxWidth, double maxHeight) {
    angle += angleSpeed; // Rotate the particle slowly
    height += speed; // Move vertically at a slower speed

    // Wrap the height to loop particles from top to bottom
    if (height > maxHeight) {
      height = 0;
    }

    // Calculate DNA helix positions
    x = maxWidth / 2 + radius * cos(angle); // Left and right oscillation
    y = height; // Vertical movement
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class DNA4thParticleAnimation extends StatefulWidget {
  final Widget child;

  const DNA4thParticleAnimation({super.key, required this.child});

  @override
  State<DNA4thParticleAnimation> createState() =>
      _DNA4thParticleAnimationState();
}

class _DNA4thParticleAnimationState extends State<DNA4thParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<DNAParticle> _strandA;
  late List<DNAParticle> _strandB;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize strands with evenly spaced particles
    _strandA = List.generate(80, (index) => DNAParticle());
    _strandB = List.generate(80, (index) => DNAParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black), // Black background
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: DNAPainter(_strandA, _strandB, _controller),
        ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class DNAPainter extends CustomPainter {
  final List<DNAParticle> strandA;
  final List<DNAParticle> strandB;
  final AnimationController controller;

  DNAPainter(this.strandA, this.strandB, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..color = Colors.blue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final Paint corePaint = Paint()..color = Colors.blue;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    for (int i = 0; i < strandA.length; i++) {
      final particleA = strandA[i];
      final particleB = strandB[i];

      // Update positions
      particleA.update(size.width, size.height, i, true);
      particleB.update(size.width, size.height, i, false);

      // Draw particles
      canvas.drawCircle(Offset(particleA.x, particleA.y), 4, corePaint);
      canvas.drawCircle(Offset(particleA.x, particleA.y), 12, glowPaint);

      canvas.drawCircle(Offset(particleB.x, particleB.y), 4, corePaint);
      canvas.drawCircle(Offset(particleB.x, particleB.y), 12, glowPaint);

      // Draw base pair (line between particles)
      canvas.drawLine(
        Offset(particleA.x, particleA.y),
        Offset(particleB.x, particleB.y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DNAParticle {
  double x = 0;
  double y = 0;
  final double radius = 100.0; // Radius of helix
  final double speed = 0.3; // Vertical speed
  final double frequency = 0.5; // Frequency of oscillation

  void update(double width, double height, int index, bool isStrandA) {
    final double offset = index * 0.1; // Spread particles vertically
    final double angle =
        (DateTime.now().millisecondsSinceEpoch / 1000) * frequency + offset;

    // X position: oscillating for DNA strand
    x = width / 2 + (isStrandA ? -radius : radius) * cos(angle);

    // Y position: continuous downward movement
    // y = (height + index * 10 - (DateTime.now().millisecondsSinceEpoch / 10) * speed) %
    //     height;
    y = height / 60 +
        index * 10; // Set fixed vertical position with a gap of 30
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class BrainShapeParticleAnimation extends StatefulWidget {
  final Widget child;

  const BrainShapeParticleAnimation({super.key, required this.child});

  @override
  State<BrainShapeParticleAnimation> createState() =>
      _BrainShapeParticleAnimationState();
}

class _BrainShapeParticleAnimationState
    extends State<BrainShapeParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _brainPath;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize brain path
    _brainPath = _generateBrainPath();
    _particles = List.generate(
      300,
      (index) => Particle(
        position: _brainPath[index % _brainPath.length],
        angle: 2 * pi * (index / 300),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: BrainPainter(_particles, _controller),
        ),
        Center(child: widget.child), // Overlay child widget
      ],
    );
  }

  // Generates the path representing the brain shape
  List<Offset> _generateBrainPath() {
    List<Offset> path = [];
    final double width = 200; // Adjust for desired size
    final double height = 300;

    final Offset center = Offset(200, 300); // Center of the brain shape

    // Define the outline of a brain (approximate)
    for (double angle = 0; angle < 2 * pi; angle += 0.01) {
      final double lobeX =
          width * 0.5 * cos(angle) * (1 + 0.1 * sin(3 * angle));
      final double lobeY =
          height * 0.3 * sin(angle) * (1 + 0.2 * sin(2 * angle));
      path.add(center + Offset(lobeX, lobeY));
    }

    return path;
  }
}

class BrainPainter extends CustomPainter {
  final List<Particle> particles;
  final AnimationController controller;

  BrainPainter(this.particles, this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..color = Colors.blue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final Paint corePaint = Paint()..color = Colors.blue;

    for (final particle in particles) {
      particle.update();
      final Offset position = particle.getPosition();
      canvas.drawCircle(position, 5, glowPaint); // Glow
      canvas.drawCircle(position, 2.5, corePaint); // Core
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final Offset position;
  final double angle; // Used for oscillating movement
  double time = 0;

  Particle({required this.position, required this.angle});

  void update() {
    time += 0.02; // Increment time for oscillation
  }

  Offset getPosition() {
    // Oscillate slightly around the path
    final double dx = 5 * sin(angle + time);
    final double dy = 5 * cos(angle + time);
    return position + Offset(dx, dy);
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class NeuralNetworkAnimation extends StatefulWidget {
  final Widget child;

  const NeuralNetworkAnimation({super.key, required this.child});

  @override
  State<NeuralNetworkAnimation> createState() => _NeuralNetworkAnimationState();
}

class _NeuralNetworkAnimationState extends State<NeuralNetworkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<NeuralNode> _nodes;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Initialize nodes (neuron-like points)
    _nodes = _generateNodes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: NeuralNetworkPainter(_nodes, _controller),
        ),
        Center(child: widget.child), // Overlay child widget
      ],
    );
  }

  // Generate random nodes for the neural network
  List<NeuralNode> _generateNodes() {
    final List<NeuralNode> nodes = [];
    final Random random = Random();

    for (int i = 0; i < 20; i++) {
      nodes.add(
        NeuralNode(
          position: Offset(
            100 + random.nextDouble() * 200, // Random X within a region
            200 + random.nextDouble() * 300, // Random Y within a region
          ),
        ),
      );
    }

    return nodes;
  }
}

class NeuralNetworkPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final AnimationController controller;

  NeuralNetworkPainter(this.nodes, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()..color = Colors.blue;
    final Paint connectionPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final Paint particlePaint = Paint()..color = Colors.red;

    // Draw nodes and connections
    for (final node in nodes) {
      canvas.drawCircle(node.position, 8, nodePaint);

      // Connect this node to a few other nodes
      for (final other in nodes) {
        if (node != other && Random().nextBool()) {
          canvas.drawLine(node.position, other.position, connectionPaint);

          // Animate particles along the connection
          final particlePosition = node.getParticlePosition(
            other.position,
            controller.value,
          );
          canvas.drawCircle(particlePosition, 4, particlePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeuralNode {
  final Offset position;

  NeuralNode({required this.position});

  Offset getParticlePosition(Offset target, double progress) {
    final double dx = target.dx - position.dx;
    final double dy = target.dy - position.dy;

    return Offset(
      position.dx + dx * progress,
      position.dy + dy * progress,
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class AdvancedNeuralNetworkAnimation extends StatefulWidget {
  final Widget child;

  const AdvancedNeuralNetworkAnimation({super.key, required this.child});

  @override
  State<AdvancedNeuralNetworkAnimation> createState() =>
      _AdvancedNeuralNetworkAnimationState();
}

class _AdvancedNeuralNetworkAnimationState
    extends State<AdvancedNeuralNetworkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AdvancedNeuralNode> _nodes;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Initialize nodes (neuron-like points)
    _nodes = _generateNodes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          Container(color: Colors.black,),
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: AdvancedNeuralNetworkPainter(_nodes, _controller),
          ),
          Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Adjust blur intensity
          child: Container(
            color: Colors.transparent, // Transparent container to apply the blur
          ),
        ),
      ),
          Center(child: widget.child), // Overlay child widget
        ],
      ),
    );
  }

  // Generate random nodes for the neural network
  List<AdvancedNeuralNode> _generateNodes() {
    final List<AdvancedNeuralNode> nodes = [];
    const int layers = 5; // Number of layers
    const int nodesPerLayer = 2; // Nodes per layer

    for (int layer = 0; layer < layers; layer++) {
      for (int i = 0; i < nodesPerLayer; i++) {
        nodes.add(
          AdvancedNeuralNode(
            position: Offset(
              50 + _random.nextDouble() * 300, // Random X within a region
              100 +
                  layer * 150 +
                  _random.nextDouble() * 50, // Layered Y position
            ),
            isHighlighted: false,
          ),
        );
      }
    }

    return nodes;
  }

  void _handleTap(TapDownDetails details) {
    final Offset tapPosition = details.localPosition;

    for (final node in _nodes) {
      if ((node.position - tapPosition).distance < 20) {
        setState(() {
          node.isHighlighted = true;
        });

        // Reset highlight after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            node.isHighlighted = false;
          });
        });
        break;
      }
    }
  }
}

class AdvancedNeuralNetworkPainter extends CustomPainter {
  final List<AdvancedNeuralNode> nodes;
  final AnimationController controller;
  // final Random _random = Random(); // Add this to define _random

  AdvancedNeuralNetworkPainter(this.nodes, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()..color = const Color.fromARGB(75, 33, 149, 243);
    final Paint glowPaint = Paint()
      ..color = const Color.fromARGB(125, 33, 149, 243)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final Paint connectionPaint = Paint()
      ..color = const Color.fromARGB(15, 255, 255, 255)
      ..strokeWidth = 2;

    final Paint highlightedConnectionPaint = Paint()
      ..color = const Color.fromARGB(75, 255, 235, 59)
      ..strokeWidth = 3;

    final Paint particlePaint = Paint()..color = const Color.fromARGB(99, 244, 67, 54);

    // Draw nodes and connections
    for (final node in nodes) {
      for (final other in nodes) {
        if (node != other
        // && _random.nextBool()
        ) {
          // Use the fixed _random here
          // Dynamic fading effect
          connectionPaint.color = const Color.fromARGB(5, 255, 255, 255);
          canvas.drawLine(
            node.position,
            other.position,
            node.isHighlighted ? highlightedConnectionPaint : connectionPaint,
          );

          // Animate particles along the connection
          final particlePosition = node.getParticlePosition(
            other.position,
            controller.value,
          );
          canvas.drawCircle(particlePosition, 4, particlePaint);
        }
      }

      // Draw the node with glow
      canvas.drawCircle(node.position, 8, nodePaint);
      canvas.drawCircle(node.position, 12, glowPaint);

      // Highlighted effect
      if (node.isHighlighted) {
        final Paint highlightPaint = Paint()
          ..color =  Colors.black
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15);
        canvas.drawCircle(node.position, 20, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AdvancedNeuralNode {
  final Offset position;
  bool isHighlighted;

  AdvancedNeuralNode({required this.position, this.isHighlighted = false});

  Offset getParticlePosition(Offset target, double progress) {
    final double dx = target.dx - position.dx;
    final double dy = target.dy - position.dy;

    return Offset(
      position.dx + dx * progress,
      position.dy + dy * progress,
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class OrganizedNeuralNetwork extends StatefulWidget {
  final Widget child;

  const OrganizedNeuralNetwork({super.key, required this.child});

  @override
  State<OrganizedNeuralNetwork> createState() => _OrganizedNeuralNetworkState();
}

class _OrganizedNeuralNetworkState extends State<OrganizedNeuralNetwork>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<OrganizedNeuralNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Initialize organized nodes in a layered structure
    _nodes = _createLayeredStructure();
  }

  List<OrganizedNeuralNode> _createLayeredStructure() {
    const int layers = 5; // Number of layers
    const int nodesPerLayer = 5; // Nodes in each layer
    final double horizontalGap = 50; // Horizontal spacing between layers
    final double verticalGap = 100; // Vertical spacing between nodes

    List<OrganizedNeuralNode> nodes = [];
    for (int layer = 0; layer < layers; layer++) {
      for (int node = 0; node < nodesPerLayer; node++) {
        double x = layer * horizontalGap + 80; // X position of the layer
        double y = node * verticalGap + 150; // Y position of the node
        nodes.add(OrganizedNeuralNode(position: Offset(x, y)));
      }
    }
    return nodes;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black), // Black background
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: OrganizedNeuralNetworkPainter(_nodes, _controller),
        ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class OrganizedNeuralNetworkPainter extends CustomPainter {
  final List<OrganizedNeuralNode> nodes;
  final AnimationController controller;
  final Random _random = Random();

  OrganizedNeuralNetworkPainter(this.nodes, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()..color = Colors.blue;
    final Paint glowPaint = Paint()
      ..color = Colors.blue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    final Paint connectionPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final Paint particlePaint = Paint()
      ..color = Colors.red; // Keep particle color constant

    // Draw nodes and connections
    for (final node in nodes) {
      for (final other in nodes) {
        // Connect nodes between layers only
        if (node.position.dx < other.position.dx - 40 &&
            _random.nextDouble() < 0.1) {
          // Draw connection line
          connectionPaint.color = Colors.white10;
          canvas.drawLine(
            node.position,
            other.position,
            connectionPaint,
          );

          // Animate particles along the connection (no opacity change, just movement)
          final particlePosition = node.getParticlePosition(
            other.position,
            controller.value,
          );
          canvas.drawCircle(
              particlePosition, 4, particlePaint); // Keep particle visible
        }
      }

      // Draw the node with glow
      canvas.drawCircle(node.position, 8, nodePaint);
      canvas.drawCircle(node.position, 20, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OrganizedNeuralNode {
  Offset position;
  bool isHighlighted;

  OrganizedNeuralNode({required this.position, this.isHighlighted = false});

  Offset getParticlePosition(Offset target, double progress) {
    return Offset(
      position.dx + (target.dx - position.dx) * progress,
      position.dy + (target.dy - position.dy) * progress,
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class Organized2ndNeuralNetwork extends StatefulWidget {
  final Widget child;

  const Organized2ndNeuralNetwork({super.key, required this.child});

  @override
  State<Organized2ndNeuralNetwork> createState() =>
      _Organized2ndNeuralNetworkState();
}

class _Organized2ndNeuralNetworkState extends State<Organized2ndNeuralNetwork>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Node> _nodes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Initialize organized nodes in a layered structure
    _nodes = _createLayeredStructure();
  }

  List<Node> _createLayeredStructure() {
    const int layers = 5; // Number of layers
    const int nodesPerLayer = 5; // Nodes in each layer
    final double horizontalGap = 50; // Horizontal spacing between layers
    final double verticalGap = 100; // Vertical spacing between nodes

    List<Node> nodes = [];
    for (int layer = 0; layer < layers; layer++) {
      for (int node = 0; node < nodesPerLayer; node++) {
        double x = layer * horizontalGap + 80; // X position of the layer
        double y = node * verticalGap + 150; // Y position of the node
        nodes.add(Node(position: Offset(x, y)));
      }
    }
    return nodes;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black), // Black background
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: Organized2ndNeuralNetworkPainter(_nodes, _controller),
        ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class Organized2ndNeuralNetworkPainter extends CustomPainter {
  final List<Node> nodes;
  final AnimationController controller;
  final Random _random = Random();

  Organized2ndNeuralNetworkPainter(this.nodes, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()..color = Colors.blue;
    final Paint glowPaint = Paint()
      ..color = Colors.blue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    final Paint connectionPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final Paint particlePaint = Paint()..color = Colors.red;

    // Draw nodes and connections
    for (final node in nodes) {
      for (final other in nodes) {
        // Connect nodes between layers with random chance
        if (node.position.dx < other.position.dx - 40 &&
            _random.nextDouble() < 0.2) {
          // Draw connection line with fading effect
          connectionPaint.color = Colors.white;
          canvas.drawLine(
            node.position,
            other.position,
            connectionPaint,
          );

          // Animate particles along the connection line (more fluid)
          final particlePosition = node.getParticlePosition(
            other.position,
            controller.value,
          );
          canvas.drawCircle(particlePosition, 4, particlePaint);
        }
      }

      // Draw the node with pulsing effect
      final double nodeSize =
          8 + 2 * sin(controller.value * 2 * pi); // Pulsing effect
      canvas.drawCircle(node.position, nodeSize, nodePaint);
      canvas.drawCircle(node.position, nodeSize + 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Node {
  Offset position;
  bool isHighlighted;

  Node({required this.position, this.isHighlighted = false});

  Offset getParticlePosition(Offset target, double progress) {
    return Offset(
      position.dx + (target.dx - position.dx) * progress,
      position.dy + (target.dy - position.dy) * progress,
    );
  }
}



/////////////////////////////////////////////////////////////////////////////////////
class AIThoughtProcessAnimation extends StatefulWidget {
  final Widget child;

  const AIThoughtProcessAnimation({super.key, required this.child});

  @override
  State<AIThoughtProcessAnimation> createState() =>
      _AIThoughtProcessAnimationState();
}

class _AIThoughtProcessAnimationState extends State<AIThoughtProcessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AIThoughtParticle> _particles;
  final int _particleCount = 50; // Number of particles
  // final double _radius = 100.0; // Radius of the circular path

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Repeat animation for continuous motion

    // Initialize particles in circular motion
    _particles =
        List.generate(_particleCount, (index) => AIThoughtParticle(index));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: AIPainter(_particles, _controller),
        ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class AIPainter extends CustomPainter {
  final List<AIThoughtParticle> particles;
  final AnimationController controller;

  AIPainter(this.particles, this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Particle color
      ..style = PaintingStyle.fill;

    // Calculate the center point of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Loop through the particles and update their position
    for (final particle in particles) {
      particle.update(center, controller.value);
      canvas.drawCircle(
          Offset(particle.x, particle.y), 6, paint); // Draw each particle
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AIThoughtParticle {
  final int index;
  double x = 0.0;
  double y = 0.0;
  double angle = 0.0;

  AIThoughtParticle(this.index);

  void update(Offset center, double animationValue) {
    // Calculate angle based on particle index and animation value
    angle = (index * 2 * pi / 50) + animationValue * 2 * pi;

    // Calculate the x, y position based on angle and radius
    x = center.dx + 100 * cos(angle);
    y = center.dy + 100 * sin(angle);
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class AIThought3rdProcessAnimation extends StatefulWidget {
  final Widget child;

  const AIThought3rdProcessAnimation({super.key, required this.child});

  @override
  State<AIThought3rdProcessAnimation> createState() =>
      _AIThought3rdProcessAnimationState();
}

class _AIThought3rdProcessAnimationState
    extends State<AIThought3rdProcessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AIThought3rdParticle> _layer1Particles;
  late List<AIThought3rdParticle> _layer2Particles;
  late List<AIThought3rdParticle> _layer3Particles;

  final int _particleCount = 50; // Number of particles per layer
  final double _radiusLayer1 = 100.0; // Radius for Layer 1
  final double _radiusLayer2 = 150.0; // Radius for Layer 2
  final double _radiusLayer3 = 200.0; // Radius for Layer 3

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true); // Repeat animation for continuous motion

    // Initialize particles in each layer
    _layer1Particles = List.generate(_particleCount,
        (index) => AIThought3rdParticle(index, _radiusLayer1, 0.3));
    _layer2Particles = List.generate(_particleCount,
        (index) => AIThought3rdParticle(index, _radiusLayer2, 0.5));
    _layer3Particles = List.generate(_particleCount,
        (index) => AIThought3rdParticle(index, _radiusLayer3, 0.7));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: AIThought3rdAIPainter(_layer1Particles, _layer2Particles,
              _layer3Particles, _controller),
        ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class AIThought3rdAIPainter extends CustomPainter {
  final List<AIThought3rdParticle> layer1Particles;
  final List<AIThought3rdParticle> layer2Particles;
  final List<AIThought3rdParticle> layer3Particles;
  final AnimationController controller;

  AIThought3rdAIPainter(this.layer1Particles, this.layer2Particles,
      this.layer3Particles, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintLayer1 = Paint()
      ..color = Colors.blue // Particle color for Layer 1
      ..style = PaintingStyle.fill;

    final Paint paintLayer2 = Paint()
      ..color = Colors.green // Particle color for Layer 2
      ..style = PaintingStyle.fill;

    final Paint paintLayer3 = Paint()
      ..color = Colors.red // Particle color for Layer 3
      ..style = PaintingStyle.fill;

    // Calculate the center point of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Loop through the particles in each layer and update their position
    for (final particle in layer1Particles) {
      particle.update(center, controller.value);
      canvas.drawCircle(Offset(particle.x, particle.y), 6,
          paintLayer1); // Draw each particle in Layer 1
    }

    for (final particle in layer2Particles) {
      particle.update(center, controller.value);
      canvas.drawCircle(Offset(particle.x, particle.y), 6,
          paintLayer2); // Draw each particle in Layer 2
    }

    for (final particle in layer3Particles) {
      particle.update(center, controller.value);
      canvas.drawCircle(Offset(particle.x, particle.y), 6,
          paintLayer3); // Draw each particle in Layer 3
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AIThought3rdParticle {
  final int index;
  double x = 0.0;
  double y = 0.0;
  final double radius; // Radius of the orbit for the particle
  final double speed; // Speed of movement for the particle

  AIThought3rdParticle(this.index, this.radius, this.speed);

  void update(Offset center, double animationValue) {
    // Calculate angle based on particle index and animation value
    double angle = (index * 2 * pi / 50) + animationValue * speed;

    // Calculate the x, y position based on angle and radius
    x = center.dx + radius * cos(angle);
    y = center.dy + radius * sin(angle);
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class AIThought2ndProcessAnimation extends StatefulWidget {
  final Widget child;

  const AIThought2ndProcessAnimation({super.key, required this.child});

  @override
  State<AIThought2ndProcessAnimation> createState() =>
      _AIThought2ndProcessAnimationState();
}

class _AIThought2ndProcessAnimationState
    extends State<AIThought2ndProcessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<AIThought2ndParticle> _particles;
  final int _particleCount = 100; // Number of particles
  final double _radius = 100.0; // Radius of the spiral path

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true); // Repeat animation for continuous motion

    // Initialize particles in spiral motion
    _particles = List.generate(
        _particleCount, (index) => AIThought2ndParticle(index, _radius));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black,),
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: AIThought2ndAIPainter(_particles, _controller),
        ),
        Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Adjust blur intensity
          child: Container(
            color: Colors.transparent, // Transparent container to apply the blur
          ),
        ),
      ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class AIThought2ndAIPainter extends CustomPainter {
  final List<AIThought2ndParticle> particles;
  final AnimationController controller;

  AIThought2ndAIPainter(this.particles, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Calculate the center point of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Loop through the particles and update their position
    for (final particle in particles) {
      particle.update(center, controller.value);
      paint.color = particle.getColor(); // Dynamic color for each particle
      canvas.drawCircle(
          Offset(particle.x, particle.y), 6, paint); // Draw each particle
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AIThought2ndParticle {
  final int index;
  double x = 0.0;
  double y = 0.0;
  double angle = 0.0;
  double spiralFactor = 0.5; // Determines how much particles move outward
  double speed = 0.0; // Speed of each particle
  final double radius; // Radius of the spiral path

  AIThought2ndParticle(this.index, this.radius) {
    // Assign random speeds to particles
    speed = Random().nextDouble() * 0.2 + 0.05;
  }

  void update(Offset center, double animationValue) {
    // Calculate angle based on particle index and animation value
    angle = (index * 2 * pi / 100) + animationValue * 2 * pi;

    // Increase the spiral factor over time to make particles spiral outward
    double dynamicRadius = radius + (spiralFactor * animationValue * 200);

    // Calculate the x, y position based on angle, radius, and spiral effect
    x = center.dx + dynamicRadius * cos(angle);
    y = center.dy + dynamicRadius * sin(angle);
  }

  Color getColor() {
    // Create a dynamic color transition
    return Color.lerp(Colors.blue, Colors.green, speed)!;
  }
}


/////////////////////////////////////////////////////////////////////////////////////
class DigitalCityAnimation extends StatefulWidget {
  final Widget child;

  const DigitalCityAnimation({super.key, required this.child});

  @override
  State<DigitalCityAnimation> createState() => _DigitalCityAnimationState();
}

class _DigitalCityAnimationState extends State<DigitalCityAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<CityParticle> particles;
  List<Building>? buildings;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Building> _createNonOverlappingBuildings(double width, double height,
      {int minBuildings = 15, int maxBuildings = 20, double minGap = 20.0}) {
    List<Building> buildingList = [];
    final random = Random();

    // Generate a random number of buildings within the specified range (inclusive)
    final int buildingCount =
        random.nextInt(maxBuildings - minBuildings + 1) + minBuildings;

    for (int i = 0; i < buildingCount; i++) {
      // Randomly choose whether the building is vertical or horizontal
      final isVertical = random.nextBool();

      // Random x position with the minimum gap
      final double x =
          random.nextDouble() * (width - Building.maxWidth - minGap) + minGap;

      // Random y position with the minimum gap
      final double y =
          random.nextDouble() * (height - Building.maxHeight - minGap) + minGap;

      // Create a building at the random position
      final building = Building(x, y, isVertical);

      // Ensure no overlap with other buildings
      if (buildingList.every((other) => !building.overlaps(other))) {
        buildingList.add(building);
      }
    }

    return buildingList;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
// Define the size of the background you want to cover
    final double backgroundWidth = screenWidth *.8;  // Set the width of the background
    final double backgroundHeight = screenHeight *.6; // Set the height of the background

    // Create a list of particles
    particles = List.generate(100, (index) => CityParticle(backgroundWidth, backgroundHeight));
    // Create buildings if not already created
    buildings ??= _createNonOverlappingBuildings(
      screenWidth*.9, screenHeight*.9, minBuildings: 200, maxBuildings: 300,
      minGap: 30, // Increase gap to 30.0
    );

    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: Container(
                width: backgroundWidth,
                height: backgroundHeight,
                decoration: BoxDecoration(
                  color: Colors.black,  // Set background color
                ),
                child: CustomPaint(
                  size: Size(backgroundWidth, backgroundHeight),  // Use custom size for painting
                  painter: CityPainter(particles, buildings!, _controller),
              ),
                      ),
            ),
          ),),
          // Apply a blur effect on top of the animation
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Adjust blur intensity
          child: Container(
            color: Colors.transparent, // Transparent container to apply the blur
          ),
        ),
      ),
        widget.child, // Overlay child widget
      ],
    );
  }
}

class CityPainter extends CustomPainter {
  final List<CityParticle> particles;
  final List<Building> buildings;
  final AnimationController controller;
  Random random = Random();

  CityPainter(this.particles, this.buildings, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint particlePaint = Paint()
      ..color = Colors.lightBlueAccent.shade700
      ..style = PaintingStyle.fill;

    // final Paint roadPaint = Paint()
    //   ..color = Colors.grey
    //   ..style = PaintingStyle.fill;

    // Draw roads
    // canvas.drawRect(
    //     Rect.fromLTWH(0, size.height - 100, size.width, 100), roadPaint);

    // Draw buildings
    for (var building in buildings) {
      building.draw(canvas);
    }

    // Update and draw each particle
    for (var particle in particles) {
      particle.update(size.width, size.height, buildings, random);  // Pass buildings for avoidance
      canvas.drawCircle(Offset(particle.x, particle.y), 5, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class CityParticle {
  double x = 0;
  double y = 0;
  double speedX = 0;
  double speedY = 0;
  double angle = 0; // Angle to determine direction of movement
  static const double constantSpeed = 0.1; // Set constant speed

  CityParticle(double containerWidth, double containerHeight) {
    // Random initial positions and directions within the black container
    final random = Random();
    x = random.nextDouble() * containerWidth; // Restrict within container width
    y = random.nextDouble() * containerHeight; // Restrict within container height
    // speedX = random.nextDouble() * 2 - 1; // Random horizontal speed
    // speedY = random.nextDouble() * 2 - 1; // Random vertical speed
    speedX = cos(angle) * constantSpeed;
    speedY = sin(angle) * constantSpeed;
    angle = random.nextDouble() * 1 * pi; // Random initial angle
  }

  // Update particle position based on its speed
  void update(double width, double height, List<Building> buildings, random) {
    // Move the particle
    x += speedX;
    y += speedY;

    // Check if the particle is near a building and adjust direction smoothly
    for (var building in buildings) {
      if (_isNearBuilding(building)) {
        _avoidBuilding(building
        // ,random
        );
      }
    }

    // Keep particles within bounds
    if (x < 0 || x > width) speedX = -speedX;
    if (y < 0 || y > height) speedY = -speedY;
  }

  // Check if the particle is too close to a building
  bool _isNearBuilding(Building building) {
    // Check if the particle is in the region near the building's edges
    return x > building.x - 5 &&
        x < building.x + building.width + 3 &&
        y > building.y - 4 &&
        y < building.y + building.height + 2;
  }

  // Avoid the building by adjusting the particle's direction
  void _avoidBuilding(Building building
  // , random
  ) {
    // Calculate the direction to the center of the building
    double dx = x - (building.x + building.width / 2);  // Horizontal distance to the center of the building
    double dy = y - (building.y + building.height / 2); // Vertical distance to the center of the building
    
    // Normalize the direction vector
    double magnitude = sqrt(dx * dx + dy * dy);
    dx /= magnitude;
    dy /= magnitude;

    // Apply the constant speed
    speedX = dx * constantSpeed;
    speedY = dy * constantSpeed;

    // Un comment this if you want random speed of particles
    // // If the particle is near the building, change direction
    // if (dx.abs() < building.width / 2 && dy.abs() < building.height / 2) {
    //   // Check if there's enough space on the side to move around
    //   if (dx.abs() > building.width / 2) {
    //     // Move horizontally if possible
    //     speedX = (dx > 0) ? -1.5 : 1.5;
    //     speedY = random.nextDouble() * 2 - 1; // Add some vertical randomness
    //   } else if (dy.abs() > building.height / 2) {
    //     // Move vertically if possible
    //     speedX = random.nextDouble() * 2 - 1; // Add some horizontal randomness
    //     speedY = (dy > 0) ? -1.5 : 1.5;
    //   } else {
    //     // Random angle adjustment if not in a gap
    //     angle += pi / 4; // Gradually adjust angle to move around the building
    //   }
    // } else {
    //   // Keep moving randomly if not near a building
    //   angle += (Random().nextDouble() - 0.5) * pi / 8; // Small random angle adjustment
    // }

    // // Update the particle's movement direction
    // speedX = cos(angle) * 2; // Horizontal speed
    // speedY = sin(angle) * 2; // Vertical speed
  }
}

class Building {
  final double x;
  final double y;
  final double width;
  final double height;

  static const double minWidth = 30.0;
  static const double maxWidth = 100.0;
  static const double minHeight = 50.0;
  static const double maxHeight = 300.0;

  Building(this.x, this.y, bool isVertical)
      : width = isVertical
            ? _randomInRange(minWidth, maxWidth / 4)
            : _randomInRange(minWidth, maxWidth / 10),
        height = isVertical
            ? _randomInRange(minHeight, maxHeight / 20)
            : _randomInRange(minHeight, maxHeight / 10);

  bool overlaps(Building other) {
    return x < other.x + other.width &&
        x + width > other.x &&
        y < other.y + other.height &&
        y + height > other.y;
  }

  void draw(Canvas canvas) {
    final Paint paint = Paint()
      ..color = Colors.blue.shade900
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(x, y, width, height), paint);
  }

  static double _randomInRange(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
}


class TTSReactiveAnimation extends StatelessWidget {
  final RxDouble frequency;

  const TTSReactiveAnimation({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Smooth transition for scaling and rotation
      final scale = 1.0 + frequency.value * 0.5;  // Reduce the scale factor for smoother effect
      final rotation = (frequency.value * 2 * 3.14159) % (2 * 3.14159);  // Rotation based on frequency for a smooth spin effect
      
      return Center(
        child: Transform(
          transform: Matrix4.identity()
            ..scale(scale)  // Apply scaling
            ..rotateZ(rotation),  // Apply rotation
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),  // Smooth transition duration
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.blueAccent, Colors.transparent],
                stops: [frequency.value, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TTS2ndReactiveAnimation extends StatelessWidget {
  final RxDouble frequency;

  const TTS2ndReactiveAnimation({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use sine wave for smoother, more natural scaling and opacity transition
      final scale = 1.0 + (0.5 * (1 + sin(frequency.value * 2 * pi)));  // Smooth pulse with sine wave
      final opacity = (0.5 + 0.5 * sin(frequency.value * 2 * pi)).clamp(0.4, 1.0);  // Opacity oscillation

      // Dynamically adjust the shadow's blur and spread based on the frequency
      final shadowBlurRadius = 30 + (frequency.value * 20).clamp(0.0, 50.0);  // Blur radius based on frequency
      final shadowSpreadRadius = 5 + (frequency.value * 10).clamp(0.0, 20.0); // Spread radius based on frequency

      // Sine wave for rotation as well for an even more dynamic effect
      final rotation = sin(frequency.value * 2 * pi) * 0.2;  // Rotate slightly for dynamic movement

      return Center(
        child: Transform(
          transform: Matrix4.identity()
            ..scale(scale)  // Apply dynamic scaling
            ..rotateZ(rotation),  // Apply rotation
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),  // Smooth transition for properties
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.blueAccent.withOpacity(opacity), // Gradient opacity oscillates
                  Colors.transparent
                ],
                stops: [frequency.value.clamp(0.0, 1.0), 1.0],  // Dynamic gradient transition
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: shadowBlurRadius, // Dynamic blur
                  spreadRadius: shadowSpreadRadius, // Dynamic spread
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TTS3rdReactiveAnimation extends StatelessWidget {
  final RxDouble frequency;

  const TTS3rdReactiveAnimation({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final scale = 1.0 + frequency.value * 0.5;  // Smooth scale effect
      final rotation = (frequency.value * 2 * 3.14159) % (2 * 3.14159);  // Smooth rotation effect
      final randomFactor = Random().nextDouble() * 0.2; // Irregular shape factor

      return Center(
        child: Transform(
          transform: Matrix4.identity()
            ..scale(scale)  // Apply scale
            ..rotateZ(rotation),  // Apply rotation
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 100 + randomFactor * 20, // Introduce irregular shape (distortion)
            height: 100 + randomFactor * 20,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // Changed to rectangle to allow irregular shapes
              borderRadius: BorderRadius.circular(30), // Rounded edges
              gradient: RadialGradient(
                colors: [Colors.blueAccent, Colors.transparent],
                stops: [frequency.value, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CustomPaint(
              painter: SmokeEffectPainter(frequency: frequency.value),
            ),
          ),
        ),
      );
    });
  }
}

class SmokeEffectPainter extends CustomPainter {
  final double frequency;

  SmokeEffectPainter({required this.frequency});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final smokeRadius = 20 + frequency * 30; // Increase smoke size based on frequency

    // Draw smoke with a subtle spread
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        center.translate(
          Random().nextDouble() * 30 - 15, // Randomize position slightly for smoke
          Random().nextDouble() * 30 - 15,
        ),
        smokeRadius + Random().nextDouble() * 10, // Randomize radius for dynamic smoke
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Always repaint to show the updated smoke effect
  }
}


class TTS4thReactiveAnimation extends StatefulWidget {
  final RxDouble frequency;

  const TTS4thReactiveAnimation({super.key, required this.frequency});

  @override
  _TTS4thReactiveAnimationState createState() => _TTS4thReactiveAnimationState();
}

class _TTS4thReactiveAnimationState extends State<TTS4thReactiveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller to drive all animations
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Animating scale (pulse effect)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animating rotation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Animating opacity for smoke
    _opacityAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Floating effect (moving up and down)
    _floatingAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 10)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final scale = 1.0 + widget.frequency.value * 0.2;  // Scale based on frequency
      final rotation = (widget.frequency.value * 2 * pi) % (2 * pi);  // Smooth rotation

      final randomFactor = Random().nextDouble() * 0.2;  // Irregular shape

      return Center(
        child: Transform(
          transform: Matrix4.identity()
            ..scale(_scaleAnimation.value * scale)  // Combined static and pulse scale
            ..rotateZ(_rotationAnimation.value + rotation),  // Combined rotation and dynamic rotation
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 100 + randomFactor * 20,  // Irregular shape size
            height: 100 + randomFactor * 20,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30),
              gradient: RadialGradient(
                colors: [Colors.blueAccent, Colors.transparent],
                stops: [widget.frequency.value, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: Smoke4thEffectPainter(
                      frequency: widget.frequency.value,
                      opacity: _opacityAnimation.value,  // Apply animated opacity to smoke
                    ),
                  ),
                ),
                SlideTransition(
                  position: _floatingAnimation,  // Floating effect
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Smoke4thEffectPainter extends CustomPainter {
  final double frequency;
  final double opacity;

  Smoke4thEffectPainter({required this.frequency, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final smokeRadius = 20 + frequency * 30;  // Increase smoke size based on frequency

    // Draw smoke with random spread
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        center.translate(
          Random().nextDouble() * 30 - 15,  // Randomize position for smoke
          Random().nextDouble() * 30 - 15,
        ),
        smokeRadius + Random().nextDouble() * 10,  // Random radius for smoke
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Always repaint to show the updated smoke effect
  }
}


class TTS5thReactiveAnimation extends StatefulWidget {
  final RxDouble frequency;

  const TTS5thReactiveAnimation({super.key, required this.frequency});

  @override
  _TTS5thReactiveAnimationState createState() => _TTS5thReactiveAnimationState();
}

class _TTS5thReactiveAnimationState extends State<TTS5thReactiveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller to drive all animations
    _controller = AnimationController(
      duration: Duration(seconds: 4),  // Slow down the animation for a calming effect
      vsync: this,
    )..repeat(reverse: true);

    // Slow pulse effect for gentle scaling
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slow and continuous rotation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Soft opacity changes for smoke
    _opacityAnimation = Tween<double>(begin: 0.1, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Subtle floating effect (moving up and down slowly)
    _floatingAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 5)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final scale = 1.0 + widget.frequency.value*.5;  // Gentle scaling based on frequency
      final rotation = (widget.frequency.value * 2 * pi) % (2 * pi);  // Smooth dynamic rotation

      final randomFactor = Random().nextDouble() * 0.1;  // Reduced random shape factor for subtlety

      return Center(
        child: Transform(
          transform: Matrix4.identity()
            ..scale(_scaleAnimation.value * scale)  // Gentle scale effect
            ..rotateZ(_rotationAnimation.value + rotation),  // Continuous rotation effect
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 100 + randomFactor * 20,  // Subtle irregularity
            height: 100 + randomFactor * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.lightBlueAccent.withOpacity(0.6), Colors.transparent],
                stops: [widget.frequency.value, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: Smoke5thEffectPainter(
                      frequency: widget.frequency.value,
                      opacity: _opacityAnimation.value,  // Apply soft opacity for smoke
                    ),
                  ),
                ),
                SlideTransition(
                  position: _floatingAnimation,  // Apply subtle floating animation
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Smoke5thEffectPainter extends CustomPainter {
  final double frequency;
  final double opacity;

  Smoke5thEffectPainter({required this.frequency, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(opacity)  // Softer color for calming effect
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final smokeRadius = 20 + frequency * 15;  // Soft smoke radius change based on frequency

    // Draw smoke particles with gradual spread
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        center.translate(
          Random().nextDouble() * 15 - 7.5,  // Reduced random spread for softness
          Random().nextDouble() * 15 - 7.5,
        ),
        smokeRadius + Random().nextDouble() * 5,  // Softer smoke radius for calming effect
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Always repaint to update the smoke effect
  }
}

