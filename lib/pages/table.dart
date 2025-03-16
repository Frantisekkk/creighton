import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/TableLogic.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/widgets/tablePage/CycleRowWidget.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  late TableLogic tableLogic;
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final appState = Provider.of<AppState>(context, listen: false);
      tableLogic = TableLogic(appState: appState); // Create TableLogic instance
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    tableLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableLogic>.value(
      value: tableLogic, // Provide the TableLogic instance to descendants
      child: Consumer<TableLogic>(
        builder: (context, tableLogic, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cycle Table Display')),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (tableLogic.cycleData == null ||
                        tableLogic.cycleData!.isEmpty)
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CycleRowWidget(
                              cycleData: [],
                              rowHeight: 300,
                              tableLogic: tableLogic,
                            ),
                          ),
                        )
                      ]
                    : tableLogic.cycleData!.reversed.map((cycle) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CycleRowWidget(
                              cycleData: cycle,
                              rowHeight: 300,
                              tableLogic: tableLogic,
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
