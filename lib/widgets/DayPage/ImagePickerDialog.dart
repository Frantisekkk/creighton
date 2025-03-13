import 'dart:ui';
import 'package:flutter/material.dart';

class StickerPickerDialog extends StatefulWidget {
  final Color initialColor;
  final bool initialBabySelection;

  const StickerPickerDialog({
    Key? key,
    required this.initialColor,
    this.initialBabySelection = false,
  }) : super(key: key);

  @override
  _StickerPickerDialogState createState() => _StickerPickerDialogState();
}

class _StickerPickerDialogState extends State<StickerPickerDialog> {
  late Color selectedColor;
  bool showBaby = false;

  final List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.white
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
    showBaby = widget.initialBabySelection;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double dialogWidth = MediaQuery.of(context).size.width * 0.8;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth),
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
                      'Select Your Sticker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Color Picker Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: availableColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedColor == color
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),

                    // Baby Selection Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Include Baby:",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Switch(
                          value: showBaby,
                          onChanged: (value) {
                            setState(() {
                              showBaby = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Display Selected Sticker with baby overlay if applicable
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 130,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        if (showBaby)
                          Positioned(
                            bottom: 10,
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                'assets/images/baby_transparent.jpg', // Updated baby overlay asset path
                                width: 70,
                                height: 70,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Done Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop({
                          'color': selectedColor,
                          'showBaby': showBaby,
                        });
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
