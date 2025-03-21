import 'package:flutter_application_1/controllers/TableLogic.dart';
import 'package:flutter_application_1/widgets/tablePage/OptionPciekr.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';

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
    // final tableLogic = Provider.of<TableLogic>(context, listen: false);
    final tableLogic = context.read<TableLogic>();
    return SizedBox(
      height: rowHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeader(
            context,
            "Day",
            (data) => data['day_order']?.toString() ?? 'N/A',
            height: rowHeight * 0.1,
          ),
          _buildRowHeader(
            context,
            "Sticker",
            (data) => '',
            height: rowHeight * 0.3,
            iconBuilder: (data) {
              final Color stickerColor = getColor(data['sticker'] ?? 'unknown');
              final bool baby = data['baby'] ?? false;
              return InkWell(
                onTap: () async {
                  // Pass tableLogic to the dialog so it doesn't look it up later.
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
                    // Show confirmation dialog before creating a new cycle
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm New Cycle'),
                          content: Text(
                              'Are you sure you want to create a new cycle on ${data['date']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      await tableLogic.createNewCycle(context);
                      print("Creating new cycle at date: ${data['date']}");
                    }
                  } else if (selectedAction == 'delete') {
                    // Show confirmation before deleting the cycle
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Cycle?'),
                          content: Text(
                              'Are you sure you want to delete this cycle? All its days will be merged with the previous cycle.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete'),
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
            "Date",
            (data) {
              final rawDate = data['date']?.toString();
              if (rawDate == null || rawDate.isEmpty) return 'N/A';
              try {
                final parsedDate = DateTime.parse(rawDate);
                return DateFormat('d/M/yy').format(parsedDate);
              } catch (e) {
                return 'Invalid Date';
              }
            },
            height: rowHeight * 0.1,
          ),
          _buildRowHeader(
            context,
            "Bleeding",
            (data) => data['bleeding'] ?? 'N/A',
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            context,
            "Mucus",
            (data) => data['mucus'] ?? 'N/A',
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            context,
            "Fertility",
            (data) => data['fertility'] ?? 'N/A',
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
    // Build each data cell (or a placeholder if there's no data).
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
          // Header Cell
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
          // Data Cells (or placeholder if empty)
          Row(children: dataCells),
        ],
      ),
    );
  }
}
