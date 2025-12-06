// lib/services/trip_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../config/api_config.dart';
import '../models/trip.dart';
import '../models/trip_response.dart';
import '../models/calendar_trip.dart';

class TripService {
  // ----------------------------------------------------------------------
  // 🔐 Firebase Access Token 가져오기
  // ----------------------------------------------------------------------
  static Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  // ----------------------------------------------------------------------
  // 1) 홈 화면 여행 목록 조회
  // GET /trips?limit=10&status=active
  // ----------------------------------------------------------------------
  static Future<TripResponse> fetchTrips({
    int limit = 10,
    String status = "active",
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception("로그인 후 이용해주세요.");

    final uri = Uri.parse(
      "${ApiConfig.baseUrl}${ApiConfig.trips}?limit=$limit&status=$status",
    );

    print("📤 [TripService] GET $uri");

    final res = await http.get(uri, headers: ApiConfig.headers(authToken: token));

    print("📥 [TripService] Response(${res.statusCode}): ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("여행 목록 조회 실패");
    }

    return TripResponse.fromJson(jsonDecode(res.body));
  }

  // ----------------------------------------------------------------------
  // 2) 캘린더 여행 조회
  // GET /calendar/trips?year=YYYY&month=MM
  // ----------------------------------------------------------------------
  static Future<List<CalendarTrip>> fetchCalendarTrips({
    required int year,
    required int month,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception("로그인 후 이용해주세요.");

    final uri = Uri.parse(
      "${ApiConfig.baseUrl}${ApiConfig.calendarTrips}?year=$year&month=$month",
    );

    print("📤 [TripService] GET $uri");

    final res = await http.get(uri, headers: ApiConfig.headers(authToken: token));

    print("📥 [TripService] Response(${res.statusCode}): ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("캘린더 여행 조회 실패");
    }

    final body = jsonDecode(res.body);
    final items = body['items'] as List? ?? [];

    return items.map((e) => CalendarTrip.fromJson(e)).toList();
  }

  // ----------------------------------------------------------------------
  // 3) 여행 생성 (POST /trips)
  // ----------------------------------------------------------------------
  static Future<Trip> createTrip(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) throw Exception("로그인 후 이용해주세요.");

    final uri = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.trips}");

    print("📤 [TripService] POST $uri");
    print("📦 Body: $data");

    final res = await http.post(
      uri,
      headers: ApiConfig.headers(authToken: token),
      body: jsonEncode(data),
    );

    print("📥 [TripService] Response(${res.statusCode}): ${res.body}");

    if (res.statusCode != 201) {
      throw Exception("여행 생성 실패");
    }

    return Trip.fromJson(jsonDecode(res.body));
  }

  // ----------------------------------------------------------------------
  // 4) 단일 여행 조회
  // GET /trips/:tripId
  // ----------------------------------------------------------------------
  static Future<Trip> fetchTrip(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception("로그인 후 이용해주세요.");

    final uri = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.trips}/$id");

    print("📤 [TripService] GET $uri");

    final res = await http.get(uri, headers: ApiConfig.headers(authToken: token));

    print("📥 [TripService] Response(${res.statusCode}): ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("여행 조회 실패");
    }

    return Trip.fromJson(jsonDecode(res.body));
  }

  // ----------------------------------------------------------------------
  // 5) Mock 데이터 (API 연동 전 테스트용)
  // ----------------------------------------------------------------------
  static Future<TripResponse> getMockTrips() async {
    await Future.delayed(const Duration(milliseconds: 500)); // 지연 시뮬레이션

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
      "nextCursor": null,
    };

    return TripResponse.fromJson(mockData);
  }
}
