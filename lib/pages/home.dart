import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/graph_calculation.dart';
import 'package:intl/intl.dart';

// Make sure these imports exist and point to your actual files.
import '../pages/login_page.dart';
import '../pages/profil_page.dart';
import '../../api_services/stickerService.dart';

class HomePage extends StatelessWidget {
  final String userName;

  // Single service instance for color fetches.
  final StickerService _stickerService = StickerService();

  HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    // We subtract the bottom navigation bar height to get a "usable" height.
    final double screenHeightWithoutBottomNav =
        screenHeight - kBottomNavigationBarHeight;

    // Current date strings, used in color fetches and display.
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // GREETING SECTION (inlined)
                Container(
                  color: const Color.fromRGBO(169, 15, 159, 0.75),
                  height: screenHeightWithoutBottomNav / 2 * 0.4,
                  child: Stack(
                    children: [
                      // Greeting text
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, bottom: 10.0),
                          child: Text(
                            'Ahoj $userName \u{1F44B}', // 👋
                            style: TextStyle(
                              fontSize:
                                  (screenHeightWithoutBottomNav / 2 * 0.4) / 4,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Borel',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Profile icon leading to ProfilePage
                      Positioned(
                        top: 40,
                        right: 15,
                        child: IconButton(
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // COLOR DISPLAY CONTAINER (inlined)
                Container(
                  padding: const EdgeInsets.all(30),
                  height: screenHeightWithoutBottomNav / 2 * 0.75,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(169, 15, 159, 0.75),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<Color>(
                    future: _stickerService.fetchColorByDate(todayDate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final Color color = snapshot.data ?? Colors.grey;
                      return Container(
                        padding: const EdgeInsets.all(16.0),
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
                            // First half: rectangle with aspect ratio
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 3.7 / 5, // Height-to-width ratio
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Second half: date + text
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('E dd.MM')
                                        .format(DateTime.now()),
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  const Divider(
                                      color: Colors.grey, thickness: 1),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Selected Color',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // WEEKLY STICKERS ROW (inlined)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  height: screenHeightWithoutBottomNav / 8,
                  child: FutureBuilder<List<Color>>(
                    future: _stickerService.fetchColorsForLastWeek(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<Color> colors =
                          snapshot.data ?? List.filled(7, Colors.grey);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          // e.g. from 6 days ago to "today"
                          DateTime date = DateTime.now().subtract(
                            Duration(days: 6 - index),
                          );
                          final color = colors[index].withOpacity(0.7);
                          return Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(19),
                                border:
                                    Border.all(color: Colors.grey, width: 0.8),
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
                    },
                  ),
                ),

                // CIRCULAR PROGRESS INDICATOR SECTION
                Container(
                  height: screenHeightWithoutBottomNav / 2 * 0.5,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Use our separate CustomPainter class for the semi-circle graph
                      CustomPaint(
                        size: const Size(200, 100),
                        painter: CustomCircularProgress(value: 0.75),
                      ),
                      // Text overlay
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
