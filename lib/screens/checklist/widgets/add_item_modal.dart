/// AddItemModal - 체크리스트 항목 추가/수정 모달
///
/// [기능]
/// - 새 항목 추가 모드 (isEditMode: false)
/// - 기존 항목 수정 모드 (isEditMode: true)
///
/// [사용법]
/// ```dart
/// // 추가 모드
/// AddItemModal(
///   onSave: (title) { /* 저장 로직 */ },
/// )
///
/// // 수정 모드
/// AddItemModal(
///   isEditMode: true,
///   initialTitle: "기존 제목",
///   onSave: (title) { /* 수정 로직 */ },
/// )
/// ```
import 'package:flutter/material.dart';

class AddItemModal extends StatefulWidget {
  final Function(String title) onSave;
  final String? initialTitle;
  final bool isEditMode;

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
    // 수정 모드인 경우 기존 제목으로 초기화
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    // 텍스트 변경 시 버튼 활성화 상태 업데이트를 위한 리스너
    _titleController.addListener(() {
      setState(() {}); // 버튼 활성화 상태 업데이트
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// 저장 버튼 클릭 시 실행되는 메서드
  ///
  /// [동작]
  /// 1. 제목이 비어있지 않은지 확인
  /// 2. onSave 콜백 실행 (부모 위젯에서 처리)
  /// 3. 모달 닫기
  void handleSave() {
    if (_titleController.text.isNotEmpty) {
      widget.onSave(_titleController.text);
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
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEditMode ? '항목 수정' : '새 항목 추가',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

          // 항목 제목
          const Text(
            '항목 제목',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
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
            autofocus: true,
          ),
          const SizedBox(height: 24),

          // 버튼
          Row(
            children: [
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
