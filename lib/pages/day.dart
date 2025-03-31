import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/DayPage/ImagePickerDialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/widgets/DayPage/temperature_picker.dart';
import 'package:flutter_application_1/controllers/DayLogic.dart';
import 'package:flutter_application_1/widgets/DayPage/ButtonSection.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
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
                            initialBabySelection: dayLogic.baby,
                            peak: dayLogic.selectedPeak,
                          ),
                        );
                        if (result != null) {
                          Color selectedColor = result['color'];
                          bool showBaby = result['showBaby'];
                          String peakLabel = result['label'] ?? '';
                          await dayLogic.updateStickerColor(
                              selectedColor, showBaby);
                          await dayLogic.updatePeak(peakLabel);
                        }
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 3.7 / 5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: dayLogic.stickerColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.4),
                                ),
                              ),
                              if (dayLogic.baby)
                                Image.asset(
                                  'assets/images/baby_transparent.png',
                                  fit: BoxFit.contain,
                                  width: 70,
                                ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    dayLogic.selectedPeak != ''
                                        ? dayLogic.selectedPeak
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 80,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                          label: localizations.abdominal_pain,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // "Start New Cycle" Button
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await dayLogic.startNewCycle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttBackgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  localizations.start_new_cycle,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            // Bleeding Section
            ButtonSection(
              title: localizations.bleeding,
              options: const [
                ['B', 'VL', 'L', 'M', 'H']
              ],
              selectedValue: dayLogic.selectedBleeding,
              onPressed: (value) async {
                await dayLogic.updateBleeding(value);
              },
            ),
            // Description Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Base description options
                ButtonSection(
                  title: localizations.description_label,
                  options: const [
                    ['0', '2', '2W', '4'],
                    ['6', '8', '10'],
                  ],
                  selectedValue: dayLogic.baseMucus,
                  onPressed: (value) async {
                    // Update only the base portion.
                    await dayLogic.updateMucus(value + "");
                  },
                ),
                // Additional description options – shown if base is one of 6,8,10
                if (['6', '8', '10'].contains(dayLogic.baseMucus))
                  Container(
                    decoration: BoxDecoration(
                      color: headerContainerBackgroundColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ButtonSection(
                      title: '',
                      options: const [
                        ['B', 'C', 'C/K', 'G'],
                        ['K', 'L', 'P', 'Y']
                      ],
                      selectedValue: dayLogic.additionalMucus,
                      unselectedColor: buttonTextColor,
                      textColor: textColorDark,
                      onPressed: (value) async {
                        // Combine the base mucus with the additional value.
                        await dayLogic.updateMucus(dayLogic.baseMucus + value);
                      },
                    ),
                  ),
                // Optional third row if needed
                ButtonSection(
                  title: '',
                  options: const [
                    ['10DL', '10SL', '10WL']
                  ],
                  selectedValue: dayLogic.selectedMucus,
                  onPressed: (value) async {
                    await dayLogic.updateMucus(value);
                  },
                ),
              ],
            ),
            // Fertility Section
            ButtonSection(
              title: localizations.fertility,
              options: const [
                ['X1', 'X2', 'X3', 'AD']
              ],
              selectedValue: dayLogic.selectedFertility,
              onPressed: (value) async {
                await dayLogic.updateFertility(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
