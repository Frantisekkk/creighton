// lib/widgets/day_page_components/ButtonSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';

class ButtonSection extends StatelessWidget {
  final String title;
  final List<List<String>> options;
  final String selectedValue;
  final Function(String) onPressed;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? textColor;

  const ButtonSection({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onPressed,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != '') _buildTitle(title),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius:
                BorderRadius.circular(20), // ✅ Corners only around whole block
          ),
          //padding: const EdgeInsets.all(8.0), // Optional: inner spacing
          child: Column(
            children: [
              ...options.map((row) => _buildButtonRow(row, context)),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: isSelected
              ? (selectedColor ?? activeButtonColor)
              : (unselectedColor ?? buttBackgroundColor),
          foregroundColor: textColor ?? buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () => onPressed(option),
        child: FittedBox(child: Text(option)),
      ),
    );
  }

  // Widget _buildButton(String option) {
  //   bool isSelected = option == selectedValue;
  //   bool isBaseButtonThatTriggersSection = ['6', '8', '10'].contains(option);
  //   bool isTriggeringSelected = isSelected && isBaseButtonThatTriggersSection;

  //   return Expanded(
  //     child: Stack(
  //       clipBehavior: Clip.none,
  //       alignment: Alignment.center,
  //       children: [
  //         if (isTriggeringSelected)
  //           Positioned(
  //             left: 20, // adjust this value as needed
  //             right: 20,
  //             top: 0,
  //             bottom: 0,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: headerContainerBackgroundColor.withOpacity(0.4),
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20)),
  //               ),
  //             ),
  //           ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(vertical: 10),
  //             backgroundColor: isSelected
  //                 ? (selectedColor ?? activeButtonColor)
  //                 : (unselectedColor ?? buttBackgroundColor),
  //             foregroundColor: textColor ?? buttonTextColor,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             elevation: 0,
  //           ),
  //           onPressed: () => onPressed(option),
  //           child: FittedBox(child: Text(option)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
