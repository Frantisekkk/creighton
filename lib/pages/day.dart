import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/DayPage/ImagePickerDialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/widgets/DayPage/temperature_picker.dart';
import 'package:flutter_application_1/controllers/DayLogic.dart';
import 'package:flutter_application_1/widgets/DayPage/ButtonSection.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/AppState.dart';

class DayPage extends StatefulWidget {
  final DateTime selectedDate;
  DayPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  late DayLogic dayLogic;
  late VoidCallback _dayLogicListener;

  @override
  void initState() {
    super.initState();

    final appState = Provider.of<AppState>(context, listen: false);
    dayLogic = DayLogic(appState: appState, initialDate: widget.selectedDate);

    _dayLogicListener = () {
      if (mounted) {
        setState(() {}); // Force UI rebuild when DayLogic updates
      }
    };

    dayLogic.addListener(_dayLogicListener);

    // Ensure data loads after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dayLogic.loadData();
    });
  }

  @override
  void dispose() {
    dayLogic.removeListener(_dayLogicListener);
    dayLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(dayLogic.selectedDate);
    String date = DateFormat('d. M. y').format(dayLogic.selectedDate);

    if (!dayLogic.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
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
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => StickerPickerDialog(
                            initialColor: dayLogic.stickerColor,
                            initialBabySelection:
                                dayLogic.baby, // Ensure this state is tracked
                          ),
                        );
                        if (result != null) {
                          Color selectedColor = result['color'];
                          bool showBaby = result['showBaby'];
                          dayLogic.updateStickerColor(selectedColor, showBaby);
                        }
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 3.7 / 5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background sticker color
                              Container(
                                decoration: BoxDecoration(
                                  color: dayLogic.stickerColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.4),
                                ),
                              ),
                              // Baby Image Overlay (if enabled)
                              if (dayLogic.baby)
                                Image.asset(
                                  'assets/images/baby_transparent.png',
                                  fit: BoxFit.contain,
                                  width: 70, // Adjust size as needed
                                ),
                            ],
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
                          onSetTemperature: (newTemp) =>
                              dayLogic.updateTemperature(newTemp),
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

            // Add this inside the Column in your build method, before the Bleeding Section

            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: double.infinity, // Stretch full width
              child: ElevatedButton(
                onPressed: () async {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  await appState.startNewCycle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttBackgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Start New Cycle',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
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
