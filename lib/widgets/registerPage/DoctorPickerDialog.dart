import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorPickerDialog extends StatefulWidget {
  final List<String> doctors;
  final String? initialDoctor;
  const DoctorPickerDialog({
    Key? key,
    required this.doctors,
    this.initialDoctor,
  }) : super(key: key);

  @override
  _DoctorPickerDialogState createState() => _DoctorPickerDialogState();
}

class _DoctorPickerDialogState extends State<DoctorPickerDialog> {
  late String selectedDoctor;

  @override
  void initState() {
    super.initState();
    selectedDoctor = widget.initialDoctor ?? widget.doctors.first;
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
                localizations.select_doctor,
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
                      selectedDoctor = widget.doctors[index];
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= widget.doctors.length)
                        return null;
                      final doctor = widget.doctors[index];
                      return Center(
                        child: Text(
                          doctor,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedDoctor == doctor
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    childCount: widget.doctors.length,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(selectedDoctor),
                child: Text(localizations.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
