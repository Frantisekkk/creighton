import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api_services/stickerService.dart';

class WeeklyStickersRow extends StatelessWidget {
  final double height;
  final StickerService _stickerService = StickerService(); // Service instance

  WeeklyStickersRow({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: height,
      child: FutureBuilder<List<Color>>(
        future: _stickerService.fetchColorsForLastWeek(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Color> colors = snapshot.data ?? List.filled(7, Colors.grey);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
              return _buildSticker(colors[index], date);
            }),
          );
        },
      ),
    );
  }

  Widget _buildSticker(Color color, DateTime date) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: Colors.grey, width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(3, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E').format(date),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Text(
              DateFormat('dd').format(date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
