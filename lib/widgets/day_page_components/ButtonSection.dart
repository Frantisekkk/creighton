import 'package:flutter/material.dart';

const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;

class ButtonSection extends StatefulWidget {
  final String title;
  final List<List<String>> options; // Multi-row button layout
  final String selectedValue;
  final Function(String, bool) onPressed; // Include toggle state in callback

  ButtonSection({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onPressed,
  });

  @override
  _ButtonSectionState createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  final Set<String> _toggledButtons = {}; // Keeps track of toggled states

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
              widget.title,
              textAlign: TextAlign.center, // Centers the text
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
          children: widget.options.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: row.map((option) {
                  final isToggled = _toggledButtons.contains(option);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isToggled ? Colors.green : buttbackroundColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isToggled) {
                          _toggledButtons.remove(option);
                        } else {
                          _toggledButtons.add(option);
                        }
                      });
                      widget.onPressed(option, !isToggled);
                    },
                    child: Text(option),
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
