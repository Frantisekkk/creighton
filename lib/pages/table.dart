import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../logic/TableLogic.dart';
import '../styles/styles.dart';

class TablePage extends StatelessWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableLogic>(
      create: (_) => TableLogic(),
      child: Consumer<TableLogic>(
        builder: (context, tableLogic, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cycle Table Display'),
            ),
            body: tableLogic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tableLogic.errorMessage.isNotEmpty
                    ? Center(child: Text('Error: ${tableLogic.errorMessage}'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tableLogic.cycleData!.reversed.map((cycle) {
                            return Padding(
                              padding: tableRowPadding,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: CycleRowWidget(
                                  cycleData: cycle,
                                  rowHeight:
                                      300, // You can adjust this if needed
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          );
        },
      ),
    );
  }
}

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
          // Data Cells
          Row(
            children: cycleData.map((data) {
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
            }).toList(),
          ),
        ],
      ),
    );
  }
}
