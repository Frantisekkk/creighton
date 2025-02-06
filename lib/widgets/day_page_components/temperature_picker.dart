import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';

class TemperaturePickerDialog extends StatefulWidget {
  final double initialTemperature;
  TemperaturePickerDialog({required this.initialTemperature});

  @override
  _TemperaturePickerDialogState createState() =>
      _TemperaturePickerDialogState();
}

class _TemperaturePickerDialogState extends State<TemperaturePickerDialog> {
  double currentTemperature = 36.0;

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
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          padding: const EdgeInsets.all(16.0),
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
                  backgroundColor: buttbackroundColor,
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
