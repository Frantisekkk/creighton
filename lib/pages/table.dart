import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/TableLogic.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/widgets/tablePage/CycleRowWidget.dart';
import 'package:provider/provider.dart';

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
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (tableLogic.cycleData == null ||
                        tableLogic.cycleData!.isEmpty)
                    ? [
                        // Always show the table with headers, even if there's no data
                        Padding(
                          padding: tableRowPadding,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CycleRowWidget(
                              cycleData: [], // Empty list = table with only headers
                              rowHeight: 300,
                            ),
                          ),
                        )
                      ]
                    : tableLogic.cycleData!.reversed.map((cycle) {
                        return Padding(
                          padding: tableRowPadding,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CycleRowWidget(
                              cycleData: cycle,
                              rowHeight: 300,
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
