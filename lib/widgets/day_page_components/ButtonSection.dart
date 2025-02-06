// lib/widgets/day_page_components/ButtonSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/widgets/day_page_components/temperature_picker.dart';

class ButtonSection extends StatelessWidget {
  final String title;
  final List<List<String>> options; // Multi-row button layout
  final String selectedValue; // The current selected value
  final Function(String) onPressed; // Callback for button press

  ButtonSection({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Bar
        SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            color: headerContainerBackgroundColor,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: buttonSectionTitleTextStyle,
            ),
          ),
        ),
        // Buttons in multiple rows
        Column(
          children: options.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((option) {
                  final isSelected = option == selectedValue;
                  return Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.green : buttbackroundColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () => onPressed(option),
                        child: FittedBox(
                          child: Text(option),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// AP button widget

// lib/widgets/day_page_components/custom_toggle_button.dart
class CustomToggleButton extends StatelessWidget {
  final bool isActive;
  final Function onTap;
  final String label;

  const CustomToggleButton({
    Key? key,
    required this.isActive,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? activeButtonColor : buttBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(label, style: buttonTextStyle),
        ),
      ),
    );
  }
}

// temperature display
// lib/widgets/day_page_components/temperature_display.dart
class TemperatureDisplay extends StatelessWidget {
  final double temperature;
  final Function onSetTemperature;

  const TemperatureDisplay({
    Key? key,
    required this.temperature,
    required this.onSetTemperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        double? selectedTemp = await showDialog<double>(
          context: context,
          builder: (context) => TemperaturePickerDialog(
            initialTemperature: temperature,
          ),
        );
        if (selectedTemp != null) {
          onSetTemperature(selectedTemp);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 18, color: textColorDark),
        ),
      ),
    );
  }
}
