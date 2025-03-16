import 'dart:ui';
import 'package:flutter/material.dart';

class CycleActionDialog extends StatelessWidget {
  final String formattedDate;
  final int dayOrder;

  const CycleActionDialog({
    Key? key,
    required this.formattedDate,
    required this.dayOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFirstDay = dayOrder == 1; // Check if it's the first day of the cycle

    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cycle Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Show Date and Day Order
              Text(
                'Date: $formattedDate',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                'Day: $dayOrder',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),

              // Buttons
              Column(
                children: [
                  // Edit This Day Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('edit'); // Return selection
                    },
                    child: const Text('Edit This Day'),
                  ),
                  const SizedBox(height: 10),

                  // Dynamic Button: "Create New Cycle" OR "Delete Cycle"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFirstDay ? Colors.redAccent : Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(isFirstDay ? 'delete' : 'create');
                    },
                    child:
                        Text(isFirstDay ? 'Delete Cycle' : 'Create New Cycle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
