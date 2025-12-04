import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/checklist_response.dart';
import '../models/trip_selector_response.dart';

class ChecklistService {
  // Firebase Auth ID Token
  static String? _authToken;

  /// 인증 토큰 설정
  static void setAuthToken(String token) {
    _authToken = token;
  }

  /// 체크리스트 조회
  /// GET /trips/{tripId}/checklist
  static Future<ChecklistResponse> getChecklist(String tripId) async {
    final url =
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tripChecklist(tripId)}');

    final response = await http.get(
      url,
      headers: ApiConfig.headers(authToken: _authToken),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChecklistResponse.fromJson(json);
    } else {
      throw Exception('체크리스트 조회 실패: ${response.statusCode}');
    }
  }

  /// 체크리스트 항목 생성
  /// POST /trips/{tripId}/checklist
  static Future<ChecklistResponse> createItem({
    required String tripId,
    required String title,
    String? category,
  }) async {
    final url =
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tripChecklist(tripId)}');

    final body = {
      'title': title,
      if (category != null) 'category': category,
    };

    final response = await http.post(
      url,
      headers: ApiConfig.headers(authToken: _authToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChecklistResponse.fromJson(json);
    } else {
      throw Exception('항목 추가 실패: ${response.statusCode}');
    }
  }

  /// 체크리스트 항목 수정
  /// PATCH /trips/{tripId}/checklist/{itemId}
  static Future<ChecklistResponse> updateItem({
    required String tripId,
    required String itemId,
    bool? checked,
    String? title,
  }) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.tripChecklist(tripId)}/$itemId');

    final body = <String, dynamic>{};
    if (checked != null) body['checked'] = checked;
    if (title != null) body['title'] = title;

    final response = await http.patch(
      url,
      headers: ApiConfig.headers(authToken: _authToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChecklistResponse.fromJson(json);
    } else {
      throw Exception('항목 수정 실패: ${response.statusCode}');
    }
  }

  /// 체크리스트 항목 삭제
  /// DELETE /trips/{tripId}/checklist/{itemId}
  static Future<ChecklistResponse> deleteItem({
    required String tripId,
    required String itemId,
  }) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.tripChecklist(tripId)}/$itemId');

    final response = await http.delete(
      url,
      headers: ApiConfig.headers(authToken: _authToken),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChecklistResponse.fromJson(json);
    } else {
      throw Exception('항목 삭제 실패: ${response.statusCode}');
    }
  }

  /// 여행 선택 모달용 경량 여행 목록 조회
  /// GET /trips/selector
  static Future<TripSelectorResponse> getTripSelector({int limit = 20}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.trips}/selector')
        .replace(queryParameters: {'limit': limit.toString()});

    final response = await http.get(
      url,
      headers: ApiConfig.headers(authToken: _authToken),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TripSelectorResponse.fromJson(json);
    } else {
      throw Exception('여행 목록 조회 실패: ${response.statusCode}');
    }
  }

  // Mock 데이터 (개발용)
  static Future<ChecklistResponse> getMockChecklist(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return ChecklistResponse(
      tripId: tripId,
      summary: ChecklistSummary(
        total: 4,
        done: 1,
        progress: 0.25,
      ),
      items: [
        ChecklistItemApi(
            id: '1', title: '여권 챙기기', checked: true, category: '서류'),
        ChecklistItemApi(
            id: '2', title: '환전하기', checked: false, category: '금융'),
        ChecklistItemApi(
            id: '3', title: '돼지코 어댑터', checked: false, category: '준비물'),
        ChecklistItemApi(
            id: '4', title: '비상약', checked: false, category: '준비물'),
      ],
    );
  }

  static Future<TripSelectorResponse> getMockTripSelector() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return TripSelectorResponse(
      items: [
        TripSelectorItem(
          id: '1',
          title: '도쿄 여행',
          country: '일본',
          city: '도쿄',
          startDate: '2026-03-15',
          endDate: '2026-03-20',
          flagEmoji: '🇯🇵',
          dDay: 110,
        ),
        TripSelectorItem(
          id: '2',
          title: '파리 여행',
          country: '프랑스',
          city: '파리',
          startDate: '2026-05-10',
          endDate: '2026-05-17',
          flagEmoji: '🇫🇷',
          dDay: 166,
        ),
      ],
    );
  }
}
