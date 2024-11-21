import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
const Color textColor = Colors.white;
const Color textColorDark = Colors.black;
const Color headerContainerBackgroundColor = Color.fromRGBO( 169, 15, 159, 0.75);
const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;

class DayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(DateTime.now());
    String date = DateFormat('yMd').format(DateTime.now());

    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text('Day Page'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                //color: headerContainerBackgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$dayName, $date',
                    style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: textColorDark),
                  ),
                  // Add your code here for Section 1
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              // decoration: BoxDecoration(
              //   color: headerContainerBackgroundColor.withOpacity(0.2),
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // padding: EdgeInsets.all(8.0),
                          height: 150,
                          color: Colors.grey.withOpacity(0.3),
                          child: Center(
                            child: Text(
                              'Picture Placeholder',
                              style: TextStyle(fontSize: 16, color: textColorDark),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => TemperaturePickerDialog(),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color:  buttbackroundColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Teplota: 36.0°C',
                                  style: TextStyle(fontSize: 18, color: textColorDark),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  buttbackroundColor,
                                foregroundColor: buttonTextColor,
                              ),
                              onPressed: () {},
                              child: Text('AP'),
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
              decoration: const BoxDecoration(
                color: headerContainerBackgroundColor,
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '🩸 Krvácanie',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15, 
                      fontWeight: FontWeight.bold
                      ),
                  ),
                  // Add your code here for Section 3
                ],
              ),
            ),
            Container(
              // margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('B'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('VL'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('L'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('M'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
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
              decoration: const BoxDecoration(
                color: headerContainerBackgroundColor,
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '       Popis',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  // Add your code here for Section 5
                ],
              ),
            ),
            Container(
              //margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // color: headerContainerBackgroundColor.withOpacity(0.6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                              backgroundColor:  buttbackroundColor,
                              foregroundColor: buttonTextColor,
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
                color: headerContainerBackgroundColor,
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '       Plodnosť',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:  textColor),
                  ),
                  // Add your code here for Section 7
                ],
              ),
            ),
            Container(
              //margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // color: headerContainerBackgroundColor.withOpacity(0.4),
                //borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X1'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X2'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {},
                        child: Text('X3'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  buttbackroundColor,
                          foregroundColor: buttonTextColor,
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

class TemperaturePickerDialog extends StatefulWidget {
  @override
  _TemperaturePickerDialogState createState() => _TemperaturePickerDialogState();
}

class _TemperaturePickerDialogState extends State<TemperaturePickerDialog> {
  double currentTemperature = 36.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Temperature',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  physics: FixedExtentScrollPhysics(),
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      currentTemperature = 35.0 + index * 0.1;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          (35.0 + index * 0.1).toStringAsFixed(1) + '°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: currentTemperature == (35.0 + index * 0.1)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: textColorDark,
                          ),
                        ),
                      );
                    },
                    childCount: 50,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  buttbackroundColor,
                  foregroundColor: buttonTextColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Done'),
              ),
            ],
          ),
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
