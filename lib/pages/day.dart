import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(DateTime.now());
    String date = DateFormat('yMMMMd').format(DateTime.now());

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Day Page'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$dayName, $date',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Add your code here for Section 1
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: Center(
                            child: Text(
                              'Picture Placeholder',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              hint: Text('Select Temperature'),
                              items: <String>['Low', 'Medium', 'High']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '🩸 Krvácanie',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  // Add your code here for Section 3
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   'Section 4',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Oval Button 1
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('VL'),
                      ),
                      // Oval Button 2
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('L'),
                      ),
                      // Oval Button 3
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('M'),
                      ),
                      // Oval Button 4
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('H'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '       Popis',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  // Add your code here for Section 5
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   'Section 6',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First Row with 4 Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('0'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('2'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('2W'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('4'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Second Row with 3 Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('6'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('8'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('10'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Third Row with 3 Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('10DL'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('10SL'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Text('10WL'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '       Plodnosť',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  // Add your code here for Section 7
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   'Section 4',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Oval Button 1
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X1'),
                      ),
                      // Oval Button 2
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X2'),
                      ),
                      // Oval Button 3
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X3'),
                      ),
                      // Oval Button 4
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('AD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DayPage(),
  ));
}
