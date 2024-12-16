import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/day_page_components/ButtonSection.dart';
import '../api_services/api_service.dart';

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

  void _updateDayData(String field, String value) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      await apiService.updateDayData(today, {field: value});
      setState(() {
        if (field == 'bleeding') {
          _selectedBleeding = value;
        } else if (field == 'mucus') {
          _selectedMucus = value;
        } else if (field == 'fertility') {
          _selectedFertility = value;
        }
      });
    } catch (e) {
      print('Error updating $field: $e');
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
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Borel',
                      color: textColorDark,
                    ),
                  ),
                ],
              ),
            ),

            // Picture Placeholder Section
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 1),
              height: 160,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
              color: headerContainerBackgroundColor.withOpacity(0.4),
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
                  Flexible(
                    flex: 1, // Takes half the row
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 3.7 / 5, // Height-to-width ratio
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '36.0°C',
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
                options: [['B', 'VL', 'L', 'M', 'H']],
                selectedValue: _selectedBleeding,
                onPressed: (value, isToggled) {
                print('$value is ${isToggled ? "toggled on" : "toggled off"}');
                _updateDayData('mucus', value);
              },
              ),
            ),

            // Description Section
            ButtonSection(
              title: 'Popis',
              options: [
                ['0', '2', '2W', '4'],  // First row
                ['6', '8', '10'],       // Second row
                ['10DL', '10SL', '10WL'] // Third row
              ],
              selectedValue: '',
              onPressed: (value, isToggled) {
                print('$value is ${isToggled ? "toggled on" : "toggled off"}');
                _updateDayData('mucus', value);
              },
            ),


            // Fertility Section
            _buildSection(
              buttonSection: ButtonSection(
                title: 'Plodnosť',
                options: [['X1', 'X2', 'X3', 'AD']],
                selectedValue: _selectedFertility,
                onPressed: (value, isToggled) {
                print('$value is ${isToggled ? "toggled on" : "toggled off"}');
                _updateDayData('mucus', value);
              },
              ),
            ),
            // Add "Popis" Section
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 4.0,
                //     offset: Offset(0, 4),
                //   ),
                // ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vlastný popis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColorDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter text here...',
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required Widget buttonSection,
  }) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: buttonSection,
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
