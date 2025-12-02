/// TripResponse - 여행 목록 조회 API 응답 모델
///
/// [사용처]
/// - HomeScreen: 여행 카드 리스트 표시
/// - TripService.getTrips() / getMockTrips() 응답
///
/// [특징]
/// - 전체 여행 정보 포함 (홈 화면용 heavy model)
/// - D-day, 진행률, 날짜 포맷팅 등 계산된 값 포함
/// - TripSelectorResponse(경량 모델)와 구분하여 사용
///
/// [페이지네이션]
/// - nextCursor: 다음 페이지 커서 (없으면 null)
import 'trip.dart';

class TripResponse {
  final List<Trip> items;
  final String? nextCursor;

  TripResponse({
    required this.items,
    this.nextCursor,
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    return TripResponse(
      items: (json['items'] as List)
          .map((e) => Trip.fromJson(e))
          .toList(),
      nextCursor: json['nextCursor'],
    );
  }
}


/// 개별 여행 항목 (홈 화면 카드 표시용)
///
/// [주요 필드]
/// - id: 여행 고유 ID
/// - title: 여행 제목
/// - country, city: 국가 및 도시
/// - flagEmoji: 국기 이모지
/// - startDate, endDate: 여행 시작/종료 날짜 (ISO 8601 문자열)
/// - nights, days: 숙박일수 및 총 일수
/// - dDay: 여행까지 남은 일수
/// - progress: 체크리스트 진행률 (0.0 ~ 1.0)
///
/// [계산 속성]
/// - dateRangeFormatted: "12.25 - 12.31" 형식
/// - tripDuration: "6박 7일" 형식
/// - progressPercentage: 진행률 퍼센트 (0 ~ 100)
class TripItem {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final int nights;
  final int days;
  final int dDay;
  final String flagEmoji;
  final double progress;

  TripItem({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.days,
    required this.dDay,
    required this.flagEmoji,
    required this.progress,
  });

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      city: json['city'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      nights: json['nights'],
      days: json['days'],
      dDay: json['dDay'],
      flagEmoji: json['flagEmoji'],
      progress: (json['progress'] as num).toDouble(),
    );
  }

  // 진행률을 퍼센트로 변환
  int get progressPercentage => (progress * 100).round();

  // 날짜 포맷 (예: 3/15 - 3/20)
  String get dateRangeFormatted {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }

  // 여행 기간 (예: 5박 6일)
  String get tripDuration => '$nights박 $days일';
}
