import 'package:flutter/material.dart';

class CycleTablePage extends StatelessWidget {
  const CycleTablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data with multiple cycles
    final List<List<Map<String, String>>> cycleData =
        List.generate(4, (cycleIndex) {
      return List.generate(30, (index) {
        return {
          "day": (index + 1).toString(),
          "sticker": [
            "red",
            "green",
            "yellow",
            "blue",
            "purple",
            "white"
          ][index % 6], // Example stickers
          "date":
              "2024-${cycleIndex + 1}-${(index + 1).toString().padLeft(2, '0')}",
          "bleeding": index % 2 == 0 ? "Yes" : "No",
          "mucus": index % 3 == 0 ? "Yes" : "No",
          "fertility": index % 4 == 0 ? "Yes" : "No",
        };
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Table Display'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cycleData.map((cycle) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: CycleRowWidget(
                  cycleData: cycle,
                  rowHeight: 300, // Fixed height
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
  final List<Map<String, String>> cycleData;
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
          _buildRowHeader("Day", (data) => data['day']!,
              height: rowHeight * 0.1),
          _buildRowHeader(
            "Sticker",
            (data) => '',
            height: rowHeight * 0.3,
            iconBuilder: (data) => Icon(
              Icons.circle,
              color: _getColor(data['sticker']!),
            ),
          ),
          _buildRowHeader("Date", (data) => data['date']!,
              height: rowHeight * 0.1),
          _buildRowHeader("Bleeding", (data) => data['bleeding']!,
              height: rowHeight * 0.2),
          _buildRowHeader("Mucus", (data) => data['mucus']!,
              height: rowHeight * 0.2),
          _buildRowHeader("Fertility", (data) => data['fertility']!,
              height: rowHeight * 0.1),
        ],
      ),
    );
  }

  Widget _buildRowHeader(
    String header,
    String Function(Map<String, String>) dataExtractor, {
    required double height,
    Widget Function(Map<String, String>)? iconBuilder,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // left header for the table
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            //whole table of data without header
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
