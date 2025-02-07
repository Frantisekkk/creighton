class DayData {
  final String color;

  DayData({required this.color});

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      color: json['color'],
    );
  }
}
