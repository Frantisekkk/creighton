import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/TableLogic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class CycleActionDialog extends StatelessWidget {
  final String formattedDate;
  final int dayOrder;
  final TableLogic tableLogic;

  const CycleActionDialog({
    Key? key,
    required this.formattedDate,
    required this.dayOrder,
    required this.tableLogic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    bool isFirstDay = dayOrder == 1;
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
              Text(
                localizations.cycle_actions, // localized "Cycle Actions"
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${localizations.date_label} $formattedDate',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                '${localizations.day} $dayOrder',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('edit');
                    },
                    child: Text(localizations.edit_day),
                  ),
                  const SizedBox(height: 10),
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
                    child: Text(isFirstDay
                        ? localizations.delete_cycle
                        : localizations.create_cycle),
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
