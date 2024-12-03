import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/day_page_components/ButtonSection.dart'; // Import ButtonSection component
import '../api_services/api_service.dart'; // Import ApiService

const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
const Color textColorDark = Colors.black;
const Color headerContainerBackgroundColor = Color.fromRGBO(169, 15, 159, 0.75);
const Color buttonTextColor = Colors.white;

class DayPage extends StatefulWidget {
  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  final ApiService apiService = ApiService();

  String _selectedBleeding = '';
  String _selectedMucus = '';
  String _selectedFertility = '';

  @override
  void initState() {
    super.initState();
    _loadDayState();
  }

  void _loadDayState() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final data = await apiService.fetchDayData(today);
      setState(() {
        _selectedBleeding = data['bleeding'] ?? '';
        _selectedMucus = data['mucus'] ?? '';
        _selectedFertility = data['fertility'] ?? '';
      });
    } catch (e) {
      print('Error loading day state: $e');
    }
  }

  void _updateBleeding(String value) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      await apiService.updateBleeding(today, value);
      setState(() {
        _selectedBleeding = value;
      });
    } catch (e) {
      print('Error updating bleeding: $e');
    }
  }

  void _updateMucus(String value) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      await apiService.updateMucus(today, value);
      setState(() {
        _selectedMucus = value;
      });
    } catch (e) {
      print('Error updating mucus: $e');
    }
  }

  void _updateFertility(String value) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      await apiService.updateFertility(today, value);
      setState(() {
        _selectedFertility = value;
      });
    } catch (e) {
      print('Error updating fertility: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(DateTime.now());
    String date = DateFormat('yMd').format(DateTime.now());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$dayName, $date',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: textColorDark,
                    ),
                  ),
                ],
              ),
            ),

            // Picture Placeholder Section
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
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
                              color: const Color.fromARGB(255, 154, 135, 157).withOpacity(0.1),
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
                            backgroundColor: const Color.fromARGB(255, 154, 135, 157),
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
            ),

            // Bleeding Section
            _buildSection(
              buttonSection: ButtonSection(
                title: '🩸 Krvácanie',
                options: ['B', 'VL', 'L', 'M', 'H'],
                selectedValue: _selectedBleeding,
                onPressed: _updateBleeding,
              ),
            ),

            // Description Section
            _buildSection(
              buttonSection: ButtonSection(
              title: 'Popis',
                options: ['0', '2', '2W', '4', '6', '8', '10'],
                selectedValue: _selectedMucus,
                onPressed: _updateMucus,
              ),
            ),

            // Fertility Section
            _buildSection(
              buttonSection: ButtonSection(
              title: 'Plodnosť',
                options: ['X1', 'X2', 'X3', 'AD'],
                selectedValue: _selectedFertility,
                onPressed: _updateFertility,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    // required String title,
    required Widget buttonSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container(
        //   margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        //   padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20),
        //   decoration: BoxDecoration(
        //     color: headerContainerBackgroundColor,
        //   ),
        //   child: Text(
        //     title,
        //     style: TextStyle(
        //       color: buttonTextColor,
        //       fontSize: 15,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: buttonSection,
        ),
      ],
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColorDark,
                ),
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
                  backgroundColor: const Color.fromARGB(255, 154, 135, 157),
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
