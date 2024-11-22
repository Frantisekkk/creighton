import 'package:flutter/material.dart';
import '../services/graph_calculation.dart';

class CircularProgressIndicatorSection extends StatelessWidget {
  final double height;

  const CircularProgressIndicatorSection({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: CustomCircularProgress(value: 0.75),
              size: const Size(200, 100),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                '${(25 * 0.75).round()}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Arial',
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
