import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/TableLogic.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/widgets/tablePage/CycleRowWidget.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  bool _hasCalledLoadData = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableLogic>(
      create: (_) => TableLogic(),
      child: Consumer<TableLogic>(
        builder: (context, tableLogic, _) {
          // Use a post-frame callback to call loadCycleData after the first build.
          if (!_hasCalledLoadData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              tableLogic.loadCycleData(context);
            });
            _hasCalledLoadData = true;
          }

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
                        // Show only table headers if no data exists.
                        Padding(
                          padding: tableRowPadding,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CycleRowWidget(
                              cycleData: [],
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
