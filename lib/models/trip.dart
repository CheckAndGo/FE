class Trip {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;   // YYYY-MM-DD
  final String endDate;     // YYYY-MM-DD
  final int nights;
  final int days;
  final int dDay;
  final String? flagEmoji;
  final double progress;     // 0~1.0
  final String? purpose;

  Trip({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.days,
    required this.dDay,
    this.flagEmoji,
    this.progress = 0.0,
    this.purpose,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      city: json['city'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      nights: json['nights'] ?? 0,
      days: json['days'] ?? 0,
      dDay: json['dDay'] ?? 0,
      flagEmoji: json['flagEmoji'],
      progress: (json['progress'] ?? 0).toDouble(),
      purpose: json['purpose'],
    );
  }

  String get formattedDateRange => "$startDate ~ $endDate";
}
