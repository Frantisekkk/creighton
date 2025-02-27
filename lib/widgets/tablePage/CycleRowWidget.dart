import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';

class CycleRowWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cycleData;
  final double rowHeight;

  const CycleRowWidget({
    Key? key,
    required this.cycleData,
    required this.rowHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeader(
            "Day",
            (data) => data['day_order']?.toString() ?? 'N/A',
            height: rowHeight * 0.1,
          ),
          _buildRowHeader(
            "Sticker",
            (data) => '',
            height: rowHeight * 0.3,
            iconBuilder: (data) => Icon(
              Icons.circle,
              color: getColor(data['sticker'] ?? 'unknown'),
            ),
          ),
          _buildRowHeader(
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
            "Bleeding",
            (data) => data['bleeding'] ?? 'N/A',
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            "Mucus",
            (data) => data['mucus'] ?? 'N/A',
            height: rowHeight * 0.2,
          ),
          _buildRowHeader(
            "Fertility",
            (data) => data['fertility'] ?? 'N/A',
            height: rowHeight * 0.1,
          ),
        ],
      ),
    );
  }

  Widget _buildRowHeader(
    String header,
    String Function(Map<String, dynamic>) dataExtractor, {
    required double height,
    Widget Function(Map<String, dynamic>)? iconBuilder,
  }) {
    // If there is no data, show one placeholder empty cell.
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
