import 'package:flutter/material.dart';

class CustomSearchIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomSearchIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: SearchIconPainter(color: color),
    );
  }
}

class SearchIconPainter extends CustomPainter {
  final Color color;

  SearchIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.45, size.height * 0.45);
    final radius = size.width * 0.44;

    canvas.drawCircle(center, radius, paint);

    final double gap = 3;
    final handleStart = Offset(
      center.dx + (radius + gap) * 0.72,
      center.dy + (radius + gap) * 0.72,
    );
    final handleEnd = Offset(handleStart.dx + 6, handleStart.dy + 6);

    canvas.drawLine(handleStart, handleEnd, paint);
  }

  @override
  bool shouldRepaint(covariant SearchIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
