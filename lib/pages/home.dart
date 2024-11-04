import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;

// (232, 51, 139, 1)
// (193, 57, 121, 1)
// (92, 44, 144, 1)
// (42, 46, 116, 1)

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav = screenHeight - kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          // Background circle peeking out from bottom and side
          Positioned(
            // bottom: -100,
            bottom: -screenHeight /1.45 ,
            left: -screenHeight/1.5,
            child: Container(
              width: screenHeight ,
              height: screenHeight ,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 196, 93, 8).withOpacity(1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // First row: One-fourth of half screen height
                Container(
                  color: Colors.grey,
                  height: (screenHeightWithoutBottomNav / 2) * 0.4,
                  alignment: Alignment.bottomLeft, // Center vertically, left align horizontally
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0), // Adjust padding as needed
                    child: Text(
                      'Ahoj $userName 👋',
                      style: TextStyle(
                        fontSize: screenHeightWithoutBottomNav / 16, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Second row: Three-quarters of half screen height (our developed container)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),  
                  ),
                  padding: const EdgeInsets.all(30),
                  height: (screenHeightWithoutBottomNav / 2) * 0.75,
                  child: Container(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(3, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              width: 38,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green, // Placeholder for the picture
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('E dd.MM').format(DateTime.now()),
                                style: const TextStyle(fontSize: 22),
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Some additional',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                              const Text(
                                'text here',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Third row: Calendar representation for the last 7 days
                Container(
                  margin:const EdgeInsets.only(top: 20),
                  // color: Colors.lightGreen,
                  height: screenHeightWithoutBottomNav / 8,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(184, 248, 10, 42),
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(color: Colors.grey, width: 0.8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10.0,
                                  offset: Offset(3, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  DateFormat('E').format(date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd').format(date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                // Fourth row: Three-quarters of half screen height
                Container(
                  // color: const Color.fromARGB(255, 222, 119, 112),
                  height: (screenHeightWithoutBottomNav / 2) * 0.50,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: CustomCircularProgress(value: 0.75), // Assuming 75% completion
                          size: Size(200, 100), // Increased the size of the graph
                        ),
                        Positioned(
                          bottom: 0, // Positioning the text towards the bottom of the graph
                          child: Text(
                            '${(25 * 0.75).round()}', // Display the current day of the ovulation cycle (assuming 25-day cycle)
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        ..strokeWidth = 25,
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
      ..strokeWidth = 25;

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
