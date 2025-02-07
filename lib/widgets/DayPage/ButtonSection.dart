// lib/widgets/day_page_components/ButtonSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';

class ButtonSection extends StatelessWidget {
  final String title;
  final List<List<String>> options;
  final String selectedValue;
  final Function(String) onPressed;

  const ButtonSection({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(title),
        ...options.map((row) => _buildButtonRow(row, context)).toList(),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      color: headerContainerBackgroundColor,
      child: Text(title,
          textAlign: TextAlign.center, style: buttonSectionTitleTextStyle),
    );
  }

  Widget _buildButtonRow(List<String> row, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row.map((option) => _buildButton(option)).toList(),
      ),
    );
  }

  Widget _buildButton(String option) {
    bool isSelected = option == selectedValue;
    return Flexible(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : buttBackgroundColor,
          foregroundColor: buttonTextColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () => onPressed(option),
        child: FittedBox(child: Text(option)),
      ),
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
