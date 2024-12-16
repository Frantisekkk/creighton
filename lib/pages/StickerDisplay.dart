import 'package:flutter/material.dart';
import '../api_services/api_service.dart';

class StickerDisplay extends StatefulWidget {
  const StickerDisplay({Key? key}) : super(key: key);

  @override
  _StickerDisplayState createState() => _StickerDisplayState();
}

class _StickerDisplayState extends State<StickerDisplay> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _dayData;
  final String selectedDate = '2024-11-19'; // Example date, replace as needed

  @override
  void initState() {
    super.initState();
    _dayData = _apiService.fetchDayData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticker Display'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dayData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found for the selected date'));
          } else {
            final dayData = snapshot.data!;
            final sticker = dayData['sticker'] ?? 'unknown'; // Replace with the sticker column
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sticker for $selectedDate:',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.circle,
                    color: _getColor(sticker),
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    sticker,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Helper function to map sticker colors
  Color _getColor(String sticker) {
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
