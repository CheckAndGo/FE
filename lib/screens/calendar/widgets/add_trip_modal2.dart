import 'package:flutter/material.dart';

import '../../../models/trip_draft.dart';

import 'add_trip_modal3.dart';

class AddTripModal2 extends StatefulWidget {
  final TripDraft draft;

  const AddTripModal2({
    super.key,
    required this.draft,
  });

  @override
  State<AddTripModal2> createState() => _AddTripModal2State();
}

class _AddTripModal2State extends State<AddTripModal2> {
  late int people;
  late TextEditingController _budgetController;
  late TextEditingController _tripNameController;
  String? selectedPurpose;

  @override
  void initState() {
    super.initState();
    people = widget.draft.people ?? 1;
    _budgetController =
        TextEditingController(text: widget.draft.budget ?? '');
    _tripNameController =
        TextEditingController(text: widget.draft.tripName ?? '');
    selectedPurpose = widget.draft.purpose;
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _tripNameController.dispose();
    super.dispose();
  }

  Widget _purposeButton(String text) {
    final selected = selectedPurpose == text;
    return Container(
      width: 168,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2E6BFF) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: selected ? Colors.white : const Color(0xFF555555),
        ),
      ),
    );
  }

  void _goNext() {
    if (selectedPurpose == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('여행 목적을 선택해주세요.')),
      );
      return;
    }

    final updatedDraft = widget.draft.copyWith(
      people: people,
      budget: _budgetController.text.trim().isEmpty
          ? null
          : _budgetController.text.trim(),
      tripName: _tripNameController.text.trim().isEmpty
          ? null
          : _tripNameController.text.trim(),
      purpose: selectedPurpose,
    );

    Navigator.pop(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTripModal3(draft: updatedDraft),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 688,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 17, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '새 여행 계획',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          //진행 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: const Color(0xffEFEFEF),
              valueColor:
              const AlwaysStoppedAnimation<Color>(Color(0xFF2E80EC)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '여행 세부사항',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 인원
                    const Text(
                      '여행 인원',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        _circleButton(Icons.remove, () {
                          if (people > 1) {
                            setState(() => people--);
                          }
                        }),
                        const SizedBox(width: 20),
                        Text(
                          '$people 명',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 20),
                        _circleButton(Icons.add, () {
                          setState(() => people++);
                        }),
                      ],
                    ),

                    const SizedBox(height: 12),

                    //예산
                    const Text(
                      '예산 (선택사항)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      controller: _budgetController,
                      hint: '예: 100만원, \$1000',
                    ),

                    const SizedBox(height: 12),

                    //여행 이름
                    const Text(
                      '여행 이름',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      controller: _tripNameController,
                      hint: '예: 유럽 여행, 일본 1달 살기',
                    ),

                    const SizedBox(height: 12),

                    //목적
                    const Text(
                      '여행 목적',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '관광'),
                              child: _purposeButton('관광'),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '비즈니스'),
                              child: _purposeButton('비즈니스'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '휴양'),
                              child: _purposeButton('휴양'),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '문화체험'),
                              child: _purposeButton('문화체험'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '친구 방문'),
                              child: _purposeButton('친구 방문'),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedPurpose = '기타'),
                              child: _purposeButton('기타'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          //확인 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: 350,
              height: 44,
              child: ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //인원 조절 버튼
  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFE5E7EB),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: Colors.black),
        ),
      ),
    );
  }

  //텍스트 필드
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
            const BorderSide(color: Color(0xFFBFBFBF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
            const BorderSide(color: Color(0xFF2E6BFF)),
          ),
        ),
      ),
    );
  }
}
