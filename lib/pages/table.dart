import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/TableLogic.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/widgets/tablePage/CycleRowWidget.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  late TableLogic tableLogic; // Hold TableLogic instance
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final appState = Provider.of<AppState>(context, listen: false);
      tableLogic = TableLogic(appState: appState); // Manually pass AppState
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    tableLogic.dispose(); // Dispose TableLogic when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableLogic>.value(
      value: tableLogic, // Provide the manually created TableLogic instance
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
