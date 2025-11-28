import 'package:intl/intl.dart';

class Trip {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final int travelerCount;
  final int? budget;
  final String? theme;
  final String? purpose;
  final List<String> lodgingTypes;
  final List<String> transportModes;

  Trip({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    this.budget,
    this.theme,
    this.purpose,
    required this.lodgingTypes,
    required this.transportModes,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      city: json['city'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      travelerCount: json['travelerCount'],
      budget: json['budget'],
      theme: json['theme'],
      purpose: json['purpose'],
      lodgingTypes: List<String>.from(json['lodgingTypes']),
      transportModes: List<String>.from(json['transportModes']),
    );
  }

  //yyyy-MM-dd → M/d 변환
  String get formattedDateRange {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final s = DateFormat('M/d').format(start);
    final e = DateFormat('M/d').format(end);
    return "$s ~ $e";
  }
}
