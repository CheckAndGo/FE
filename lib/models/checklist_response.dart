/// ChecklistResponse - 체크리스트 조회 API 응답 모델
///
/// [사용처]
/// - ChecklistScreen: 체크리스트 항목 표시
/// - ChecklistService의 모든 메서드 응답
///   (getChecklist, createItem, updateItem, deleteItem)
///
/// [구조]
/// - tripId: 해당 여행 ID
/// - summary: 전체 통계 (총 개수, 완료 개수, 진행률)
/// - items: 체크리스트 항목 리스트
///
/// [특징]
/// - CRUD 작업 후 전체 체크리스트 반환 (최신 상태 동기화)
class ChecklistResponse {
  final String tripId;
  final ChecklistSummary summary;
  final List<ChecklistItemApi> items;

  ChecklistResponse({
    required this.tripId,
    required this.summary,
    required this.items,
  });

  factory ChecklistResponse.fromJson(Map<String, dynamic> json) {
    return ChecklistResponse(
      tripId: json['tripId'] as String,
      summary:
          ChecklistSummary.fromJson(json['summary'] as Map<String, dynamic>),
      items: (json['items'] as List)
          .map(
              (item) => ChecklistItemApi.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'summary': summary.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

/// 체크리스트 요약 정보 (진행률 카드 표시용)
///
/// [필드]
/// - total: 전체 항목 개수
/// - done: 완료된 항목 개수
/// - progress: 진행률 (0.0 ~ 1.0)
///
/// [사용 예시]
/// - "3/10 항목 완료"
/// - "30% 진행률 바"
class ChecklistSummary {
  final int total;
  final int done;
  final double progress;

  ChecklistSummary({
    required this.total,
    required this.done,
    required this.progress,
  });

  factory ChecklistSummary.fromJson(Map<String, dynamic> json) {
    return ChecklistSummary(
      total: json['total'] as int,
      done: json['done'] as int,
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'done': done,
      'progress': progress,
    };
  }

  int get progressPercentage => (progress * 100).round();
}

/// 개별 체크리스트 항목
///
/// [필드]
/// - id: 항목 고유 ID
/// - title: 항목 제목 (예: "여권 챙기기")
/// - checked: 완료 여부 (true/false)
/// - category: 카테고리 (optional, 예: "서류", "준비물")
///
/// [주요 동작]
/// - 체크박스 토글: checked 값 반전
/// - 수정: title 업데이트
/// - 삭제: 리스트에서 제거
class ChecklistItemApi {
  final String id;
  final String title;
  final bool checked;
  final String? category;

  ChecklistItemApi({
    required this.id,
    required this.title,
    required this.checked,
    this.category,
  });

  factory ChecklistItemApi.fromJson(Map<String, dynamic> json) {
    return ChecklistItemApi(
      id: json['id'] as String,
      title: json['title'] as String,
      checked: json['checked'] as bool,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'checked': checked,
      if (category != null) 'category': category,
    };
  }
}
