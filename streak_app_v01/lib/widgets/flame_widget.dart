import 'package:flutter/material.dart';

class FlameWidget extends StatelessWidget {
  const FlameWidget({super.key, required this.level, this.dead = false});

  final int level;
  final bool dead;

  double get _size {
    switch (level) {
      case 1:
        return 150;
      case 2:
        return 190;
      case 3:
        return 230;
      case 4:
        return 275;
      default:
        return 125;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = !dead && level > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.18 + level * 0.05),
                  blurRadius: 35 + level * 8,
                  spreadRadius: 5 + level.toDouble(),
                ),
              ]
            : [],
      ),
      child: CustomPaint(
        painter: FlamePainter(level: level, dead: dead),
      ),
    );
  }
}

class FlamePainter extends CustomPainter {
  FlamePainter({required this.level, required this.dead});

  final int level;
  final bool dead;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 200;

    if (dead || level == 0) {
      final smoke = Paint()
        ..color = Colors.grey.shade500
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 * scale
        ..strokeCap = StrokeCap.round;
      final path = Path()
        ..moveTo(center.dx - 18 * scale, center.dy + 48 * scale)
        ..cubicTo(center.dx - 40 * scale, center.dy + 15 * scale,
            center.dx + 5 * scale, center.dy + 10 * scale,
            center.dx - 8 * scale, center.dy - 22 * scale)
        ..cubicTo(center.dx + 35 * scale, center.dy + 12 * scale,
            center.dx + 8 * scale, center.dy + 36 * scale,
            center.dx + 22 * scale, center.dy + 58 * scale);
      canvas.drawPath(path, smoke);
      return;
    }

    final outer = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFFFF5A00), Color(0xFFFFB300), Color(0xFFFFD54F)],
      ).createShader(Offset.zero & size);

    final inner = Paint()
      ..color = const Color(0xFFFFF3B0)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy + 68 * scale)
      ..cubicTo(center.dx - 60 * scale, center.dy + 64 * scale,
          center.dx - 65 * scale, center.dy + 8 * scale,
          center.dx - 25 * scale, center.dy - 12 * scale)
      ..cubicTo(center.dx - 12 * scale, center.dy - 32 * scale,
          center.dx - 16 * scale, center.dy - 54 * scale,
          center.dx + 8 * scale, center.dy - 80 * scale)
      ..cubicTo(center.dx + 13 * scale, center.dy - 48 * scale,
          center.dx + 54 * scale, center.dy - 36 * scale,
          center.dx + 50 * scale, center.dy + 4 * scale)
      ..cubicTo(center.dx + 47 * scale, center.dy + 42 * scale,
          center.dx + 26 * scale, center.dy + 63 * scale,
          center.dx, center.dy + 68 * scale)
      ..close();
    canvas.drawPath(path, outer);

    final innerPath = Path()
      ..moveTo(center.dx, center.dy + 45 * scale)
      ..cubicTo(center.dx - 27 * scale, center.dy + 39 * scale,
          center.dx - 30 * scale, center.dy + 13 * scale,
          center.dx - 9 * scale, center.dy - 2 * scale)
      ..cubicTo(center.dx + 1 * scale, center.dy - 10 * scale,
          center.dx + 2 * scale, center.dy - 23 * scale,
          center.dx + 7 * scale, center.dy - 34 * scale)
      ..cubicTo(center.dx + 28 * scale, center.dy - 11 * scale,
          center.dx + 30 * scale, center.dy + 20 * scale,
          center.dx, center.dy + 45 * scale)
      ..close();
    canvas.drawPath(innerPath, inner);
  }

  @override
  bool shouldRepaint(covariant FlamePainter oldDelegate) =>
      oldDelegate.level != level || oldDelegate.dead != dead;
}
