import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
import '../api_services/user.dart';
import '../api_services/api_service.dart';
import '../api_services/day_data.dart';

// (232, 51, 139, 1)
// (193, 57, 121, 1)
// (92, 44, 144, 1)
// (42, 46, 116, 1)

class HomePage extends StatelessWidget {
  final String userName;
  final int userId;
  final ApiService apiService = ApiService();

  HomePage({required this.userName, required this.userId});

Color _getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey; // Default color if no match found
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav = screenHeight - kBottomNavigationBarHeight;

    return FutureBuilder<DayData>(
      future: apiService.fetchDayData(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()), // Today's date
        userId: userId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data found for today'));
        } else {
          final DayData dayData = snapshot.data!;
          final Color boxColor = _getColorFromString(dayData.color);

          // For debugging
          print('Day color from API: ${dayData.color}');
          print('Parsed Color: $boxColor');

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // First row: Greeting
                      Container(
                        color: const Color.fromARGB(255, 247, 28, 64),
                        height: (screenHeightWithoutBottomNav / 2) * 0.4,
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Ahoj $userName 👋',
                            style: TextStyle(
                              fontSize: screenHeightWithoutBottomNav / 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Second row: Main container with color
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 247, 28, 64),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.all(30),
                        height: (screenHeightWithoutBottomNav / 2) * 0.75,
                        child: Container(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
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
                                      // color: boxColor,
                                    color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey, width: 0.4),
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
                                    Text(
                                      'Baby: ${dayData.baby ? 'Yes' : 'No'}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Temperature: ${dayData.temperature ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    // Add more fields as needed
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                // Third row: Calendar representation for the last 7 days
                Container(
                  margin:const EdgeInsets.only(top: 20, bottom: 10, right: 30, left: 30),
                  // color: Colors.lightGreen,
                  height: screenHeightWithoutBottomNav / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(1),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const SizedBox(height: 10),
                                Text(
                                  DateFormat('E').format(date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd').format(date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
                          size: const Size(200, 100), // Increased the size of the graph
                        ),
                        Positioned(
                          bottom: 0, // Positioning the text towards the bottom of the graph
                          child: Text(
                            '${(25 * 0.75).round()}', // Display the current day of the ovulation cycle (assuming 25-day cycle)
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
                ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
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
