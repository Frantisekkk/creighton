import 'package:flutter/material.dart';

const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;

class ButtonSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final Function(String) onPressed;

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
          width: double.infinity, // Makes the container stretch across the screen
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(8.0),
            color: const Color.fromRGBO(169, 15, 159, 0.75),
            child: Text(
              title,
              textAlign: TextAlign.center, // Centers the text
              style: const TextStyle(
                color: buttonTextColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedValue == option ? Colors.green : buttbackroundColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => onPressed(option),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
