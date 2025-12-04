/// TripSelectorResponse - 여행 선택 모달용 경량 API 응답 모델
///
/// [사용처]
/// - ChecklistScreen: 여행 선택 모달
/// - ChecklistService.getTripSelector() / getMockTripSelector() 응답
///
/// [특징]
/// - TripResponse(전체 정보)보다 가벼운 모델
/// - 선택 UI에 필요한 최소한의 정보만 포함 (ID, 제목, 날짜, D-day)
/// - 네트워크 트래픽 절감 및 빠른 로딩
class TripSelectorResponse {
  final List<TripSelectorItem> items;

  TripSelectorResponse({required this.items});

  factory TripSelectorResponse.fromJson(Map<String, dynamic> json) {
    return TripSelectorResponse(
      items: (json['items'] as List)
          .map(
              (item) => TripSelectorItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

/// 여행 선택 모달용 개별 항목 (경량 버전)
///
/// [주요 필드]
/// - id: 여행 고유 ID
/// - title: 여행 제목
/// - country, city: 국가 및 도시
/// - flagEmoji: 국기 이모지
/// - startDate, endDate: 여행 날짜
/// - dDay: D-day 값 (서버에서 계산된 값, optional)
///
/// [계산 속성]
/// - calculatedDDay: dDay 값이 없으면 자동 계산
///   (현재 날짜와 startDate 차이)
class TripSelectorItem {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final String flagEmoji;
  final int? dDay;

  TripSelectorItem({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.flagEmoji,
    this.dDay,
  });

  factory TripSelectorItem.fromJson(Map<String, dynamic> json) {
    return TripSelectorItem(
      id: json['id'] as String,
      title: json['title'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      flagEmoji: json['flagEmoji'] as String,
      dDay: json['dDay'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'country': country,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'flagEmoji': flagEmoji,
      if (dDay != null) 'dDay': dDay,
    };
  }

  DateTime get startDateTime => DateTime.parse(startDate);
  DateTime get endDateTime => DateTime.parse(endDate);

  String get dateRangeFormatted {
    final start = startDateTime;
    final end = endDateTime;
    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }

  int get calculatedDDay {
    if (dDay != null) return dDay!;
    final now = DateTime.now();
    final difference = startDateTime.difference(now).inDays;
    return difference;
  }
}
