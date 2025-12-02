import 'trip.dart';


class CalendarTrip {
  final String id;
  final String title;
  final String country;
  final String city;
  final DateTime startDate;
  final DateTime endDate;
  final String? purposeTag;

  CalendarTrip({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.purposeTag,
  });

  factory CalendarTrip.fromJson(Map<String, dynamic> json) {
    return CalendarTrip(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      purposeTag: json['purposeTag'],
    );
  }

  /// UI용 날짜 출력
  String get formattedDateRange {
    String s = "${startDate.year}-${startDate.month}-${startDate.day}";
    String e = "${endDate.year}-${endDate.month}-${endDate.day}";
    return "$s ~ $e";
  }
}
