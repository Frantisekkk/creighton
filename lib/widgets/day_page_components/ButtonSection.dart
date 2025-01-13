import 'package:flutter/material.dart';

const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;

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
            color: const Color.fromRGBO(169, 15, 159, 0.75),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: buttonTextColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
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
                  final isSelected = option ==
                      selectedValue; // Check if this button is selected
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                        ),
                        onPressed: () => onPressed(
                            option), // Trigger callback with the button value
                        child: Text(option),
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
