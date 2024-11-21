import 'package:flutter/material.dart';
import '../api_services/api_service.dart';

class StickerDisplay extends StatefulWidget {
  const StickerDisplay({Key? key}) : super(key: key);

  @override
  _StickerDisplayState createState() => _StickerDisplayState();
}

class _StickerDisplayState extends State<StickerDisplay> {
  final ApiService _apiService = ApiService();
  late Future<List<String>> _stickers;
  final String selectedDate = '2024-11-19'; // Example date, replace as needed

  @override
  void initState() {
    super.initState();
    _stickers = _apiService.fetchStickerByDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticker Display'),
      ),
      body: FutureBuilder<List<String>>(
        future: _stickers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stickers found for the selected date'));
          } else {
            final stickers = snapshot.data!;
            return ListView.builder(
              itemCount: stickers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(stickers[index], style: const TextStyle(fontSize: 18)),
                  leading: Icon(Icons.circle, color: _getColor(stickers[index])),
                );
              },
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
