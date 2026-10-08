import 'package:flutter/material.dart';
import '../widgets/flame_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    final pulseCurve = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _pulseScale = Tween<double>(begin: 0.92, end: 1.08).animate(pulseCurve);
    _pulseOpacity = Tween<double>(begin: 0.2, end: 0.42).animate(pulseCurve);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseScale,
                    child: FadeTransition(
                      opacity: _pulseOpacity,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepOrange.withValues(alpha: 0.12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.deepOrange.withValues(alpha: 0.35),
                              blurRadius: 48,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const FlameWidget(level: 1),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Looking at your flame...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
