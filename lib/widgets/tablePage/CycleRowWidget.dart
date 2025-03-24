import 'package:flutter_application_1/controllers/TableLogic.dart';
import 'package:flutter_application_1/widgets/tablePage/OptionPciekr.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CycleRowWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cycleData;
  final double rowHeight;
  final TableLogic tableLogic;

  const CycleRowWidget({
    Key? key,
    required this.cycleData,
    required this.rowHeight,
    required this.tableLogic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Using context.read to get tableLogic (if needed)
    final tableLogic = context.read<TableLogic>();
    return SizedBox(
      height: rowHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeader(
            context,
            localizations.day, // localized "Day"
            (data) => data['day_order']?.toString() ?? localizations.no_data,
            height: rowHeight * 0.1,
          ),
          _buildRowHeader(
            context,
            localizations.sticker, // localized "Sticker"
            (data) => '',
            height: rowHeight * 0.3,
            iconBuilder: (data) {
              final Color stickerColor = getColor(data['sticker'] ?? 'unknown');
              final bool baby = data['baby'] ?? false;
              return InkWell(
                onTap: () async {
                  final selectedAction = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return CycleActionDialog(
                        formattedDate: DateFormat('d/M/yy')
                            .format(DateTime.parse(data['date'])),
                        dayOrder: data['day_order'],
                        tableLogic: tableLogic,
                      );
                    },
                  );

                  if (selectedAction == 'edit') {
                    DateTime parsedDate = DateTime.parse(data['date']);
                    tableLogic.navigateToEditDay(context, parsedDate);
                  } else if (selectedAction == 'create') {
                    // Confirm new cycle creation
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(localizations.confirm_new_cycle_title),
                          content: Text(
                              '${localizations.confirm_new_cycle_content} ${data['date']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(localizations.confirm),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      await tableLogic.createNewCycle(
                          context, DateTime.parse(data['date']));
                      print("Creating new cycle at date: ${data['date']}");
                    }
                  } else if (selectedAction == 'delete') {
                    // Confirm deletion of cycle
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(localizations.delete_cycle_title),
                          content: Text(localizations.delete_cycle_content),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(localizations.delete),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      await tableLogic.deleteCycle(
                          context, DateTime.parse(data['date']));
                      print("Deleting cycle starting at: ${data['date']}");
                    }
                  }
                },
                child: Container(
                  width: tableCellWidth,
                  height: rowHeight * 0.3,
                  decoration: BoxDecoration(
                    color: stickerColor,
                  ),
                  child: baby
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/baby_transparent.png',
                            fit: BoxFit.contain,
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
          _buildRowHeader(
            context,
            localizations.date, // localized "Date"
            (data) {
              final rawDate = data['date']?.toString();
              if (rawDate == null || rawDate.isEmpty)
                return localizations.no_data;
              try {
                final parsedDate = DateTime.parse(rawDate);
                return DateFormat('d/M/yy').format(parsedDate);
              } catch (e) {
                return localizations.invalid_date;
              }
            },
            height: rowHeight * 0.1,
          ),
          _buildRowHeader(
            context,
            localizations.bleeding, // localized "Bleeding"
            (data) => data['bleeding'] ?? localizations.no_data,
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            context,
            localizations.mucus, // localized "Mucus"
            (data) => data['mucus'] ?? localizations.no_data,
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            context,
            localizations.fertility, // localized "Fertility"
            (data) => data['fertility'] ?? localizations.no_data,
            height: rowHeight * 0.1,
          ),
        ],
      ),
    );
  }

  Widget _buildRowHeader(
    BuildContext context,
    String header,
    String Function(Map<String, dynamic>) dataExtractor, {
    required double height,
    Widget Function(Map<String, dynamic>)? iconBuilder,
  }) {
    final dataCells = cycleData.isNotEmpty
        ? cycleData.map((data) {
            return Container(
              width: tableCellWidth,
              height: height,
              alignment: Alignment.center,
              decoration: tableCellDecoration,
              child: iconBuilder != null
                  ? iconBuilder(data)
                  : Text(
                      dataExtractor(data),
                      textAlign: TextAlign.center,
                    ),
            );
          }).toList()
        : [
            Container(
              width: tableCellWidth,
              height: height,
              alignment: Alignment.center,
              decoration: tableCellDecoration,
              child: Text(''),
            )
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: tableCellWidth,
            height: height,
            alignment: Alignment.center,
            decoration: tableCellDecoration,
            child: Text(
              header,
              style: tableHeaderTextStyle,
            ),
          ),
          Row(children: dataCells),
        ],
      ),
    );
  }
}
