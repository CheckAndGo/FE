/// API 공통 설정 파일
class ApiConfig {
  /// ------------------------------------------------------------
  /// ⭐ Emulator / Local Backend Base URL
  /// ------------------------------------------------------------
  /// Functions Emulator가 현재 8790 포트에서 실행 중이므로,
  /// 반드시 이 주소로 설정해야 Flutter → Emulator API 통신이 가능하다.
  ///
  /// 예:
  /// GET http://10.0.2.2:8790/checkandgo-e1045/asia-northeast3/api/trips
  /// ------------------------------------------------------------
  static const String baseUrl =
      'http://10.0.2.2:8790/checkandgo-e1045/asia-northeast3/api';

  /// ------------------------------------------------------------
  /// Endpoint paths
  /// ------------------------------------------------------------

  /// 여행 생성 / 목록 / 단일 조회
  /// GET /trips
  /// POST /trips
  /// GET /trips/{tripId}
  static const String trips = '/trips';

  /// 캘린더 여행 조회
  /// GET /calendar/trips?year=2025&month=11
  static const String calendarTrips = '/calendar/trips';

  /// 특정 여행 체크리스트 조회 / 추가 / 삭제
  /// GET /trips/{tripId}/checklist
  /// POST /trips/{tripId}/checklist
  /// DELETE /trips/{tripId}/checklist/{itemId}
  static String tripChecklist(String tripId) => '/trips/$tripId/checklist';

  /// 개별 체크리스트 아이템 삭제
  static String deleteChecklistItem(String tripId, String itemId) =>
      '/trips/$tripId/checklist/$itemId';

  /// AI 체크리스트 생성
  /// POST /trips/{tripId}/checklist/ai-generate
  static String aiChecklist(String tripId) =>
      '/trips/$tripId/checklist/ai-generate';

  /// ------------------------------------------------------------
  /// Auth header builder
  /// ------------------------------------------------------------
  static String bearerToken(String token) => 'Bearer $token';

  /// ------------------------------------------------------------
  /// Default headers
  /// ------------------------------------------------------------
  static Map<String, String> headers({String? authToken}) {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': bearerToken(authToken),
    };
  }
}
