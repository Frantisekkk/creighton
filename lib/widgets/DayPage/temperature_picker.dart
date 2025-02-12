import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';

// Widget to display the current temperature and initiate the temperature picker dialog
class TemperatureDisplay extends StatelessWidget {
  final double temperature;
  final Function(double) onSetTemperature;

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
          builder: (context) =>
              TemperaturePickerDialog(initialTemperature: temperature),
        );
        if (selectedTemp != null) {
          onSetTemperature(selectedTemp);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            '${temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 18, color: textColorDark),
          ),
        ),
      ),
    );
  }
}

// Dialog to pick a temperature
class TemperaturePickerDialog extends StatefulWidget {
  final double initialTemperature;

  const TemperaturePickerDialog({Key? key, required this.initialTemperature})
      : super(key: key);

  @override
  _TemperaturePickerDialogState createState() =>
      _TemperaturePickerDialogState();
}

class _TemperaturePickerDialogState extends State<TemperaturePickerDialog> {
  late double currentTemperature;

  @override
  void initState() {
    super.initState();
    currentTemperature = widget.initialTemperature;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Temperature', style: dialogTitleTextStyle),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      currentTemperature = 35.0 + index * 0.1;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      double temp = 35.0 + index * 0.1;
                      return Center(
                        child: Text(
                          '${temp.toStringAsFixed(1)}°C',
                          style: temperatureTextStyle.copyWith(
                            fontWeight: currentTemperature == temp
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    childCount: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttBackgroundColor,
                  foregroundColor: buttonTextColor,
                ),
                onPressed: () => Navigator.of(context).pop(currentTemperature),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
