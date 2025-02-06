// // lib/day_page.dart
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/styles/styles.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_application_1/logic/day_logic.dart';
// import '../widgets/day_page_components/ButtonSection.dart';

// class DayPage extends StatefulWidget {
//   final DateTime selectedDate;

//   DayPage({Key? key, required this.selectedDate}) : super(key: key);

//   @override
//   _DayPageState createState() => _DayPageState();
// }

// class _DayPageState extends State<DayPage> {
//   final DayLogic dayLogic = DayLogic();

//   // Local UI state mirrors the logic’s state.
//   String _selectedBleeding = '';
//   String _selectedMucus = '';
//   String _selectedFertility = '';
//   double _selectedTemperature = 36.0;
//   bool _selectedAbdominalPain = false;
//   Color _stickerColor = Colors.grey;
//   late DateTime _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.selectedDate;
//     _loadDayState();
//   }

//   Future<void> _loadDayState() async {
//     await dayLogic.loadDayState(_selectedDate);
//     _refreshState();
//   }

//   /// Copies values from [dayLogic] into the local UI state.
//   void _refreshState() {
//     setState(() {
//       _selectedBleeding = dayLogic.selectedBleeding;
//       _selectedMucus = dayLogic.selectedMucus;
//       _selectedFertility = dayLogic.selectedFertility;
//       _selectedTemperature = dayLogic.selectedTemperature;
//       _selectedAbdominalPain = dayLogic.selectedAbdominalPain;
//       _stickerColor = dayLogic.stickerColor;
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//       _loadDayState();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String dayName = DateFormat('EEEE').format(_selectedDate);
//     String date = DateFormat('d. M. y').format(_selectedDate);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header Section with clickable date
//             Container(
//               margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50),
//               padding: const EdgeInsets.all(16.0),
//               child: GestureDetector(
//                 onTap: () => _selectDate(context),
//                 child: Text(
//                   '$dayName, $date',
//                   textAlign: TextAlign.center,
//                   style: headerTextStyle,
//                 ),
//               ),
//             ),
//             // Picture Placeholder Section
//             Container(
//               margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 1),
//               height: 160,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: headerContainerBackgroundColor.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10.0,
//                     offset: Offset(3, 10),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Flexible(
//                     flex: 1,
//                     child: Center(
//                       child: AspectRatio(
//                         aspectRatio: 3.7 / 5,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: _stickerColor,
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.grey, width: 0.4),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Temperature display & picker
//                         GestureDetector(
//                           onTap: () async {
//                             double? selectedTemp = await showDialog<double>(
//                               context: context,
//                               builder: (context) => TemperaturePickerDialog(
//                                 initialTemperature: _selectedTemperature,
//                               ),
//                             );
//                             if (selectedTemp != null) {
//                               try {
//                                 await dayLogic.updateTemperature(
//                                     _selectedDate, selectedTemp);
//                                 _refreshState();
//                               } catch (e) {
//                                 print('Error updating temperature: $e');
//                               }
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               '${_selectedTemperature.toStringAsFixed(1)}°C',
//                               style: const TextStyle(
//                                   fontSize: 18, color: textColorDark),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Abdominal pain toggle button
//                         Flexible(
//                           child: GestureDetector(
//                             onTap: () async {
//                               final newValue = !_selectedAbdominalPain;
//                               try {
//                                 await dayLogic.updateAbdominalPain(
//                                     _selectedDate, newValue);
//                                 _refreshState();
//                               } catch (e) {
//                                 print('Error updating abdominal pain: $e');
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 14, horizontal: 14),
//                               decoration: BoxDecoration(
//                                 color: _selectedAbdominalPain
//                                     ? Colors.green
//                                     : buttbackroundColor,
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 5.0,
//                                     offset: Offset(2, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   'AP',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: buttonTextColor),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Bleeding Section
//             _buildSection(
//               buttonSection: ButtonSection(
//                 title: '🩸 Bleeding',
//                 options: const [
//                   ['B', 'VL', 'L', 'M', 'H']
//                 ],
//                 selectedValue: _selectedBleeding,
//                 onPressed: (value) async {
//                   try {
//                     await dayLogic.updateBleeding(_selectedDate, value);
//                     _refreshState();
//                   } catch (e) {
//                     print('Error updating bleeding: $e');
//                   }
//                 },
//               ),
//             ),
//             // Description Section
//             ButtonSection(
//               title: 'Popis',
//               options: const [
//                 ['0', '2', '2W', '4'], // First row
//                 ['6', '8', '10'], // Second row
//                 ['10DL', '10SL', '10WL'] // Third row
//               ],
//               selectedValue: _selectedMucus,
//               onPressed: (value) async {
//                 try {
//                   await dayLogic.updateMucus(_selectedDate, value);
//                   _refreshState();
//                 } catch (e) {
//                   print('Error updating mucus: $e');
//                 }
//               },
//             ),
//             // Fertility Section
//             _buildSection(
//               buttonSection: ButtonSection(
//                 title: 'Plodnosť',
//                 options: const [
//                   ['X1', 'X2', 'X3', 'AD']
//                 ],
//                 selectedValue: _selectedFertility,
//                 onPressed: (value) async {
//                   try {
//                     await dayLogic.updateFertility(_selectedDate, value);
//                     _refreshState();
//                   } catch (e) {
//                     print('Error updating fertility: $e');
//                   }
//                 },
//               ),
//             ),
//             // Custom description Section
//             Container(
//               margin: const EdgeInsets.all(20.0),
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Vlastný popis',
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: textColorDark),
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     maxLines: 4,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter text here...',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({required Widget buttonSection}) {
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: buttonSection,
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/day_page_components/temperature_picker.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/logic/day_logic.dart';
import '../widgets/day_page_components/ButtonSection.dart';

class DayPage extends StatefulWidget {
  final DateTime selectedDate;

  DayPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  late DayLogic dayLogic;

  @override
  void initState() {
    super.initState();
    dayLogic = DayLogic(widget.selectedDate);
    dayLogic.addListener(() => setState(() {})); // Refresh UI on logic changes
  }

  @override
  void dispose() {
    dayLogic.removeListener(() => setState(() {}));
    super.dispose();
  }
  // void _refreshState() {
  //   setState(() {
  //     _selectedBleeding = dayLogic.selectedBleeding;
  //     _selectedMucus = dayLogic.selectedMucus;
  //     _selectedFertility = dayLogic.selectedFertility;
  //     _selectedTemperature = dayLogic.selectedTemperature;
  //     _selectedAbdominalPain = dayLogic.selectedAbdominalPain;
  //     _stickerColor = dayLogic.stickerColor;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(dayLogic.selectedDate);
    String date = DateFormat('d. M. y').format(dayLogic.selectedDate);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section with clickable date
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50),
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => dayLogic.selectDate(context),
                child: Text(
                  '$dayName, $date',
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
            ),
            // Picture Placeholder Section
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 1),
              height: 160,
              padding: const EdgeInsets.all(16.0),
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
                    flex: 1,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 3.7 / 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: dayLogic.stickerColor,
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
                        TemperatureDisplay(
                          temperature: dayLogic.selectedTemperature,
                          onSetTemperature: dayLogic.updateTemperature,
                        ),
                        CustomToggleButton(
                          isActive: dayLogic.selectedAbdominalPain,
                          onTap: () => dayLogic.updateAbdominalPain(
                              !dayLogic.selectedAbdominalPain),
                          label: 'AP',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bleeding Section
            ButtonSection(
              title: '🩸 Bleeding',
              options: const [
                ['B', 'VL', 'L', 'M', 'H']
              ],
              selectedValue: dayLogic.selectedBleeding,
              onPressed: (value) async {
                await dayLogic.updateBleeding(value);
              },
            ),

            // Description Section
            ButtonSection(
              title: 'Popis',
              options: const [
                ['0', '2', '2W', '4'],
                ['6', '8', '10'],
                ['10DL', '10SL', '10WL']
              ],
              selectedValue: dayLogic.selectedMucus,
              onPressed: (value) async {
                await dayLogic.updateMucus(value);
              },
            ),
            // Fertility Section
            ButtonSection(
              title: 'Plodnosť',
              options: const [
                ['X1', 'X2', 'X3', 'AD']
              ],
              selectedValue: dayLogic.selectedFertility,
              onPressed: (value) async {
                await dayLogic.updateFertility(value);
              },
            ),

            // Custom description Section
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vlastný popis',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColorDark),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
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
}
