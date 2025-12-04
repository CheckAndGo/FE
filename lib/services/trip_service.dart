import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_response.dart';

class TripService {
  // Firebase Cloud Functions 베이스 URL
  // region: asia-northeast3 (서울), projectId: checkandgo-e1045
  static const String baseUrl =
      'https://asia-northeast3-checkandgo-e1045.cloudfunctions.net';

  // Firebase Auth ID Token
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  /// 여행 목록 조회
  /// [limit] 가져올 항목 수 (기본값: 10)
  /// [status] 여행 상태 (기본값: 'active')
  static Future<TripResponse> getTrips({
    int limit = 10,
    String status = 'active',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/trips').replace(queryParameters: {
        'limit': limit.toString(),
        'status': status,
      });

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TripResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trips: $e');
    }
  }

  /// 목 데이터를 반환 (API 연동 전 테스트용)
  static Future<TripResponse> getMockTrips() async {
    // 실제 API 응답과 동일한 형태의 목 데이터
    await Future.delayed(const Duration(milliseconds: 500)); // 네트워크 지연 시뮬레이션

    final mockData = {
      "items": [
        {
          "id": "trp_1",
          "title": "도쿄 여행",
          "country": "일본",
          "city": "도쿄",
          "startDate": "2026-03-15",
          "endDate": "2026-03-20",
          "nights": 5,
          "days": 6,
          "dDay": 12,
          "flagEmoji": "🇯🇵",
          "progress": 0.75
        },
        {
          "id": "trp_2",
          "title": "파리 여행",
          "country": "프랑스",
          "city": "파리",
          "startDate": "2026-04-10",
          "endDate": "2026-04-15",
          "nights": 5,
          "days": 6,
          "dDay": 38,
          "flagEmoji": "🇫🇷",
          "progress": 0.3
        }
      ],
      "nextCursor": null
    };

    return TripResponse.fromJson(mockData);
  }
}
