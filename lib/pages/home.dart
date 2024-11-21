import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
import 'package:intl/intl.dart';
import '../api_services/api_service.dart';

class HomePage extends StatelessWidget {
  final String userName;
  final ApiService _apiService = ApiService(); // Initialize the API service
  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());




  HomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav = screenHeight - kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // First row: One-fourth of half screen height
                Container(
                  // color: Color.fromARGB(255, 169, 15, 159),
                  color: const Color.fromRGBO( 169, 15, 159, 0.75),
                  // color: Colors.grey.shade300,
                  height: (screenHeightWithoutBottomNav / 2) * 0.4,
                  alignment: Alignment.bottomLeft, // Center vertically, left align horizontally
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, ), // Adjust padding as needed
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
                // Container(
                //   decoration: BoxDecoration(
                //   color: Colors.grey.shade300,
                //     borderRadius: const BorderRadius.only(
                //       bottomLeft: Radius.circular(30),
                //       bottomRight: Radius.circular(30),
                //     ),  
                //   ),
                //   padding: const EdgeInsets.all(30),
                //   height: (screenHeightWithoutBottomNav / 2) * 0.75,
                //   child: Container(
                //     clipBehavior: Clip.none,
                //     padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(30),
                //       boxShadow: const [
                //         BoxShadow(
                //           color: Colors.black12,
                //           blurRadius: 10.0,
                //           offset: Offset(3, 10),
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: FittedBox(
                //             fit: BoxFit.contain,
                //             child: Container(
                //               width: 38,
                //               height: 50,
                //               decoration: BoxDecoration(
                //                 color: const Color.fromARGB(0, 255, 255, 255), // Placeholder for the picture
                //                 borderRadius: BorderRadius.circular(10),
                //                 border: Border.all(color: Colors.grey, width: 0.4),
                //               ),
                //             ),
                //           ),
                //         ),
                //         const SizedBox(width: 20),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 DateFormat('E dd.MM').format(DateTime.now()),
                //                 style: const TextStyle(fontSize: 22),
                //               ),
                //               const Divider(
                //                 color: Colors.grey,
                //                 thickness: 1,
                //               ),
                //               const SizedBox(height: 10),
                //               const Text(
                //                 'Some additional',
                //                 style: TextStyle(fontSize: 16),
                //                 textAlign: TextAlign.left,
                //               ),
                //               const Text(
                //                 'text here',
                //                 style: TextStyle(fontSize: 16),
                //                 textAlign: TextAlign.left,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  decoration: const BoxDecoration(
                  color: Color.fromRGBO( 169, 15, 159, 0.75),
                    // color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(30),
                  height: (screenHeightWithoutBottomNav / 2) * 0.75,
                  child: FutureBuilder<List<String>>(
                    future: _apiService.fetchStickerByDate(todayDate),
                     // Fetch sticker color by date
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.data == null) {
                        return const Center(child: Text('No color data available 1'));
                      } else if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('No color data available 2'));
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching color here '));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No color data available'));
                      } else {
                        final String color = snapshot.data![0]; // Get the first color if multiple are returned
                        return Container(
                          clipBehavior: Clip.none,
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
                                      color: _getColor(color),
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
                                      'Color: $color', // Display the fetched color
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
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
                  ),
                ),
                // Third row: Calendar representation for the last 7 days
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10, right: 30, left: 30),
                  height: screenHeightWithoutBottomNav / 8,
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: _apiService.fetchStickersForLastWeek(), // Fetch sticker colors for the last 7 days
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching colors'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No color data available'));
                      } else {
                        final stickerData = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (index) {
                            DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
                            String color = stickerData[index]['color'] ?? 'grey';
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                  color: _getColor(color).withOpacity(0.7),
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
                        );
                      }
                    },
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
}


// Helper function to map colors
  Color _getColor(String color) {
    switch (color.toLowerCase()) {
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
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
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