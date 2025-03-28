import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StickerPickerDialog extends StatefulWidget {
  final Color initialColor;
  final bool initialBabySelection;
  final String peak;

  const StickerPickerDialog({
    Key? key,
    required this.initialColor,
    this.initialBabySelection = false,
    this.peak = '',
  }) : super(key: key);

  @override
  _StickerPickerDialogState createState() => _StickerPickerDialogState();
}

class _StickerPickerDialogState extends State<StickerPickerDialog> {
  late Color selectedColor;
  bool showBaby = false;
  // Label options: index 0 represents null (displayed as a dash)
  final List<String> labelOptions = ['', 'P', '1', '2', '3'];
  String selectedLabel = '';

  final List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.white
  ];

  // Make the controller nullable and lazily initialize it
  FixedExtentScrollController? _controller;
  FixedExtentScrollController get controller {
    _controller ??=
        FixedExtentScrollController(initialItem: getInitialIndex(widget.peak));
    return _controller!;
  }

  /// Mapping: if peak is empty → 0, 'P' → 1, '1' → 2, '2' → 3, '3' → 4.
  int getInitialIndex(String peak) {
    if (peak.isEmpty) return 0;
    int index = labelOptions.indexOf(peak);
    return index != -1 ? index : 0;
  }

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
    showBaby = widget.initialBabySelection;
    selectedLabel = widget.peak.isEmpty ? '' : widget.peak;
    // Do not initialize _controller here. It will be lazily created on first use.
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                    Text(
                      localizations.sticker_picker_title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double totalHorizontalMargin =
                            (availableColors.length + 1) * 8;
                        double containerWidth =
                            (constraints.maxWidth - totalHorizontalMargin) /
                                availableColors.length;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: availableColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                width: containerWidth,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selectedColor == color
                                        ? Colors.blue
                                        : Colors.black,
                                    width: selectedColor == color ? 3 : 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.include_baby,
                          style: const TextStyle(fontSize: 16),
                        ),
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: ListWheelScrollView.useDelegate(
                          controller: controller,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 60,
                          diameterRatio: 2.5,
                          perspective: 0.002,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedLabel = labelOptions[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index < 0 || index >= labelOptions.length)
                                return null;
                              // Display a dash if the value is empty.
                              String label = labelOptions[index].isEmpty
                                  ? '—'
                                  : labelOptions[index];
                              bool isSelected =
                                  selectedLabel == labelOptions[index];
                              return RotatedBox(
                                quarterTurns: -1,
                                child: Center(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blueAccent
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: labelOptions.length,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                          child: showBaby
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin: const EdgeInsets.all(20.0),
                                          child: Image.asset(
                                            'assets/images/baby_transparent.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        if (!showBaby)
                          Text(
                            selectedLabel.isEmpty ? '—' : selectedLabel,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop({
                          'color': selectedColor,
                          'showBaby': showBaby,
                          'label': selectedLabel,
                        });
                      },
                      child: Text(localizations.done),
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
