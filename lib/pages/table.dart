import 'package:flutter/material.dart';
import '../api_services/api_service.dart';
import 'package:intl/intl.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  _CycleTableState createState() => _CycleTableState();
}

class _CycleTableState extends State<TablePage> {
  final ApiService apiService = ApiService();
  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCycleData();
  }

  Future<void> _loadCycleData() async {
    try {
      final data = await apiService.fetchCycleData();
      setState(() {
        cycleData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Table Display'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cycleData!.reversed.map((cycle) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: CycleRowWidget(
                            cycleData: cycle,
                            rowHeight: 300, // Adjust the height if needed
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
              "Day", (data) => data['day_order']?.toString() ?? 'N/A',
              height: rowHeight * 0.1),
          _buildRowHeader(
            "Sticker",
            (data) => '',
            height: rowHeight * 0.3,
            iconBuilder: (data) => Icon(
              Icons.circle,
              color: _getColor(data['sticker'] ?? 'unknown'),
            ),
          ),
          _buildRowHeader(
            "Date",
            (data) {
              final rawDate = data['date']?.toString();
              if (rawDate == null || rawDate.isEmpty) return 'N/A';
              try {
                final parsedDate = DateTime.parse(rawDate);
                return DateFormat('d/M/yy')
                    .format(parsedDate); // Example format
              } catch (e) {
                return 'Invalid Date';
              }
            },
            height: rowHeight * 0.1,
          ),
          _buildRowHeader("Bleeding", (data) => data['bleeding'] ?? 'N/A',
              height: rowHeight * 0.2),
          _buildRowHeader("Mucus", (data) => data['mucus'] ?? 'N/A',
              height: rowHeight * 0.2),
          _buildRowHeader("Fertility", (data) => data['fertility'] ?? 'N/A',
              height: rowHeight * 0.1),
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
            width: 80,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Data Cells
          Row(
            children: cycleData.map((data) {
              return Container(
                width: 80,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
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

  static Color _getColor(String sticker) {
    switch (sticker.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
}
