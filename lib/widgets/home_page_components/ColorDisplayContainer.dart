import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api_services/stickerService.dart';

class ColorDisplayContainer extends StatelessWidget {
  final double height;
  final StickerService _stickerService = StickerService(); // Service instance
  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  ColorDisplayContainer({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      height: height,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(169, 15, 159, 0.75),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: FutureBuilder<Color>(
        future: _stickerService.fetchColorByDate(todayDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final Color color = snapshot.data ?? Colors.grey;
          return _buildColorDisplayContainer(color);
        },
      ),
    );
  }

  Widget _buildColorDisplayContainer(Color color) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: Offset(3, 10),
        ),
      ],
    ),
    child: Row(
      children: [
        // First Half: Rectangle (centered with aspect ratio)
        Flexible(
          flex: 1, // Takes half the row
          child: Center(
            child: AspectRatio(
              aspectRatio: 3.7 / 5, // Height-to-width ratio
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 0.4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20), // Space between the two parts
        // Second Half: Text
        Flexible(
          flex: 1, // Takes the other half of the row
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('E dd.MM').format(DateTime.now()),
                style: const TextStyle(fontSize: 22),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 10),
              const Text(
                'Selected Color',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
