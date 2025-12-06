class Trip {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;   // YYYY-MM-DD
  final String endDate;     // YYYY-MM-DD
  final int nights;
  final int days;
  final int dDay;           // 서버에서 계산된 D-day
  final String? flagEmoji;
  final double progress;    // 0~1.0
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

  // -----------------------------------------------------------
  // ① 날짜 범위 표시
  // -----------------------------------------------------------
  String get formattedDateRange => "$startDate ~ $endDate";

  // HomeScreen이 요구하는 이름과도 맞춰서 제공
  String get dateRangeFormatted => formattedDateRange;

  // -----------------------------------------------------------
  // ② n박 m일 계산
  // -----------------------------------------------------------
  String get tripDuration {
    if (nights > 0 && days > 0) {
      return "${nights}박 ${days}일";
    }
    return "${days}일";
  }

  // -----------------------------------------------------------
  // ③ progress (0~1) → 퍼센트로 변환
  // -----------------------------------------------------------
  int get progressPercentage => (progress * 100).round();

  // -----------------------------------------------------------
  // ④ D-day 계산 (서버 값 우선 사용, fallback은 직접 계산)
  // -----------------------------------------------------------
  int get calculatedDDay {
    try {
      final today = DateTime.now();
      final start = DateTime.parse(startDate);
      return start.difference(today).inDays;
    } catch (_) {
      return dDay;
    }
  }
}
