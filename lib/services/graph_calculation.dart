import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
// class for calculation and creating of the graph for the home page
class CustomCircularProgress extends CustomPainter {
  final double value;

  CustomCircularProgress({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    // Adjust the center to move the arc upwards, so only the top half is visible
    final double arcHeight = size.height;
    final double arcWidth = size.width;
    final center = Offset(arcWidth / 2, arcHeight);
    const double strokeWidth = 28;

    // Draw the background arc (semi-circle)
    canvas.drawArc(
      Rect.fromCenter(center: center, width: arcWidth, height: arcHeight * 2),
      vmath.radians(180),
      vmath.radians(180),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );

    // Draw the progress arc (semi-circle)
    const Gradient gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: 2 * math.pi,
      tileMode: TileMode.clamp,
      colors: <Color>[
        Color.fromARGB(255, 255, 68, 255),
        Color.fromARGB(255, 241, 5, 5),
      ],
    );

    Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(Rect.fromLTWH(0.0, 0.0, arcWidth, arcHeight * 2))
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCenter(center: center, width: arcWidth, height: arcHeight * 2),
      vmath.radians(180),
      vmath.radians(180 * value),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}