// lib/day_data.dart

class DayData {
  final int dayId;
  final int cycleId;
  final int dayOrder;
  final String color;
  final bool baby;
  final double? temperature;
  final bool ab;
  final String? bleeding;
  final String? mucus;
  final String? fertility;
  final DateTime createdAt;
  final DateTime updatedAt;

  DayData({
    required this.dayId,
    required this.cycleId,
    required this.dayOrder,
    required this.color,
    required this.baby,
    this.temperature,
    required this.ab,
    this.bleeding,
    this.mucus,
    this.fertility,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      dayId: json['day_id'],
      cycleId: json['cycle_id'],
      dayOrder: json['day_order'],
      color: json['color'],
      baby: json['baby'],
      temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
      ab: json['ab'],
      bleeding: json['bleeding'],
      mucus: json['mucus'],
      fertility: json['fertility'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
