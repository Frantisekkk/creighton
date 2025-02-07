import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vmath;

// A separate CustomPainter class just for the circular semi-circle graph
class CustomCircularProgress extends CustomPainter {
  final double value; // e.g. 0.75 for 75%

  CustomCircularProgress({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final double arcHeight = size.height;
    final double arcWidth = size.width;
    final center = Offset(arcWidth / 2, arcHeight);

    // Draw the background arc (semi-circle)
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: arcWidth,
        height: arcHeight * 2,
      ),
      vmath.radians(180),
      vmath.radians(180),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 30,
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
      ..shader = gradient.createShader(
        Rect.fromLTWH(0.0, 0.0, arcWidth, arcHeight * 2),
      )
      ..strokeWidth = 30;

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: arcWidth,
        height: arcHeight * 2,
      ),
      vmath.radians(180),
      vmath.radians(180 * value),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomCircularProgress oldDelegate) {
    return oldDelegate.value != value;
  }
}
