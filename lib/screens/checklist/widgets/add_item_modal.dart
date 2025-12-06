/// AddItemModal - 체크리스트 항목 추가/수정 모달
///
/// ------------------------------------------------------
/// [기능]
/// - 새 항목 추가 모드 (isEditMode: false)
/// - 기존 항목 수정 모드 (isEditMode: true)
///
/// ------------------------------------------------------
/// [사용 예시]
///
/// // 추가 모드
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => AddItemModal(
///     onSave: (title) { /* 저장 */ },
///   ),
/// );
///
/// // 수정 모드
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => AddItemModal(
///     isEditMode: true,
///     initialTitle: "여권 챙기기",
///     onSave: (updatedTitle) { /* 수정 */ },
///   ),
/// );
///
/// ------------------------------------------------------
/// [onSave]
/// 부모 위젯에서 title을 받아 저장/수정 로직을 수행한다.
/// 저장 후 자동으로 Navigator.pop() 실행.
/// ------------------------------------------------------
import 'package:flutter/material.dart';

class AddItemModal extends StatefulWidget {
  final Function(String title) onSave; // 저장 콜백
  final String? initialTitle; // 수정 모드일 때 기존 제목
  final bool isEditMode; // 수정 모드 여부

  const AddItemModal({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.isEditMode = false,
  });

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  /// 제목 입력 필드 컨트롤러
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 수정 모드: 기존 제목으로 초기값 설정
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }

    // 텍스트 변경 시 버튼 활성화 상태 반영
    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// 저장 버튼 클릭 처리
  ///
  /// 1. 빈 문자열 체크
  /// 2. 부모의 onSave(title) 실행
  /// 3. 모달 닫기
  void handleSave() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      widget.onSave(title);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------
          // 헤더
          // -------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEditMode ? '항목 수정' : '새 항목 추가',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -------------------------------
          // 제목 입력 필드
          // -------------------------------
          const Text(
            '항목 제목',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '예: 선글라스 챙기기',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Color(0xFF2E80EC), width: 2),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 24),

          // -------------------------------
          // 버튼 영역
          // -------------------------------
          Row(
            children: [
              // 취소
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 저장 / 수정
              Expanded(
                child: ElevatedButton(
                  onPressed: _titleController.text.isEmpty ? null : handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF2E80EC),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.isEditMode ? '수정하기' : '추가하기',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
