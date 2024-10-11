import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav = screenHeight - kBottomNavigationBarHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First row: One-fourth of half screen height
            Container(
              height: screenHeightWithoutBottomNav / 8,
              color: Colors.blue.shade100,
              child: const Center(
                child: Text(
                  'First Row',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Second row: Three-quarters of half screen height (our developed container)
            Container(
              height: (screenHeightWithoutBottomNav / 2) * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
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
            ),
            // Third row: One-fourth of half screen height (top border starts at middle of screen)
            Container(
              height: screenHeightWithoutBottomNav / 8,
              color: Colors.pink.shade100,
              child: const Center(
                child: Text(
                  'Third Row',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Fourth row: Three-quarters of half screen height
            Container(
              height: (screenHeightWithoutBottomNav / 2) * 0.75,
              color: Colors.yellow.shade100,
              child: const Center(
                child: Text(
                  'Fourth Row',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}