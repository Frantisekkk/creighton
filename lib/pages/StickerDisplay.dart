import 'package:flutter/material.dart';

class CycleTablePage extends StatelessWidget {
  const CycleTablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data
    final List<Map<String, String>> cycleData = List.generate(30, (index) {
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
        "date": "25-11-${(index + 1).toString().padLeft(2, '0')}",
        "bleeding": index % 2 == 0 ? "Yes" : "No",
        "mucus": index % 3 == 0 ? "Yes" : "No",
        "fertility": index % 4 == 0 ? "Yes" : "No",
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Table Display'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowHeader(
                  "Day",
                  cycleData,
                  (data) => data['day']!,
                  height: 30,
                ),
                _buildRowHeader(
                  "Sticker",
                  cycleData,
                  (data) => '',
                  height: 70,
                  iconBuilder: (data) => Icon(
                    Icons.circle,
                    color: _getColor(data['sticker']!),
                  ),
                ),
                _buildRowHeader(
                  "Date",
                  cycleData,
                  (data) => data['date']!,
                  height: 30,
                ),
                _buildRowHeader(
                  "Bleeding",
                  cycleData,
                  (data) => data['bleeding']!,
                  height: 50,
                ),
                _buildRowHeader(
                  "Mucus",
                  cycleData,
                  (data) => data['mucus']!,
                  height: 50,
                ),
                _buildRowHeader(
                  "Fertility",
                  cycleData,
                  (data) => data['fertility']!,
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Builds a row for the table with header and dynamic content
  Widget _buildRowHeader(
    String header,
    List<Map<String, String>> cycleData,
    String Function(Map<String, String>) dataExtractor, {
    Widget Function(Map<String, String>)? iconBuilder,
    double height = 50, // Default row height
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
    );
  }

  // Helper function to map sticker colors
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
