import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsultantPickerDialog extends StatefulWidget {
  final List<String> consultants;
  final String? initialConsultant;
  const ConsultantPickerDialog({
    Key? key,
    required this.consultants,
    this.initialConsultant,
  }) : super(key: key);

  @override
  _ConsultantPickerDialogState createState() => _ConsultantPickerDialogState();
}

class _ConsultantPickerDialogState extends State<ConsultantPickerDialog> {
  late String selectedConsultant;

  @override
  void initState() {
    super.initState();
    selectedConsultant = widget.initialConsultant ?? widget.consultants.first;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.select_consultant,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedConsultant = widget.consultants[index];
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= widget.consultants.length)
                        return null;
                      final consultant = widget.consultants[index];
                      return Center(
                        child: Text(
                          consultant,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedConsultant == consultant
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    childCount: widget.consultants.length,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(selectedConsultant),
                child: Text(localizations.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
