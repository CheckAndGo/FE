import 'package:flutter/material.dart';

import '../../../models/trip_draft.dart';

import 'add_trip_modal2.dart';
import 'add_trip_modal4.dart';

class AddTripModal3 extends StatefulWidget {
  final TripDraft draft;

  const AddTripModal3({
    super.key,
    required this.draft,
  });

  @override
  State<AddTripModal3> createState() => _AddTripModal3State();
}

class _AddTripModal3State extends State<AddTripModal3> {
  String? selectedStay;
  String? selectedTransport;

  @override
  void initState() {
    super.initState();
    selectedStay = widget.draft.stayType;
    selectedTransport = widget.draft.transport;
  }

  Widget _optionButton(String text, bool selected) {
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

  void _goPrev() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTripModal2(draft: widget.draft),
    );
  }

  void _goNext() {
    if (selectedStay == null || selectedTransport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('숙박 유형과 교통수단을 모두 선택해주세요.')),
      );
      return;
    }

    final updatedDraft = widget.draft.copyWith(
      stayType: selectedStay,
      transport: selectedTransport,
    );

    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTripModal4(draft: updatedDraft),
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
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "새 여행 계획",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          //진행바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: 0.75,
              backgroundColor: const Color(0xFFEFEFEF),
              valueColor:
              const AlwaysStoppedAnimation<Color>(Color(0xFF2E80EC)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "숙박 및 교통",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    //숙박 유형
                    const Text(
                      "숙박 유형",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedStay = "호텔"),
                              child: _optionButton(
                                  "호텔", selectedStay == "호텔"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedStay = "리조트"),
                              child: _optionButton(
                                  "리조트", selectedStay == "리조트"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => setState(
                                      () => selectedStay = "게스트하우스"),
                              child: _optionButton("게스트하우스",
                                  selectedStay == "게스트하우스"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedStay = "에어비엔비"),
                              child: _optionButton("에어비엔비",
                                  selectedStay == "에어비엔비"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedStay = "호스텔"),
                              child: _optionButton(
                                  "호스텔", selectedStay == "호스텔"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedStay = "기타"),
                              child: _optionButton(
                                  "기타", selectedStay == "기타"),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //교통수단
                    const Text(
                      "주요 교통수단",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF858585),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => setState(
                                      () => selectedTransport = "항공기"),
                              child: _optionButton("항공기",
                                  selectedTransport == "항공기"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTransport = "기차"),
                              child: _optionButton(
                                  "기차", selectedTransport == "기차"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTransport = "버스"),
                              child: _optionButton(
                                  "버스", selectedTransport == "버스"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTransport = "자동차"),
                              child: _optionButton("자동차",
                                  selectedTransport == "자동차"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTransport = "선박"),
                              child: _optionButton(
                                  "선박", selectedTransport == "선박"),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTransport = "기타"),
                              child: _optionButton(
                                  "기타", selectedTransport == "기타"),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          //이전 / 다음 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: _goPrev,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF2E6BFF), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "이전",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E6BFF),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "다음",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
