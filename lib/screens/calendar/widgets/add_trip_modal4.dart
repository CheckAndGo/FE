import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip.dart';
import '../../../models/trip_draft.dart';
import '../../../services/trip_service.dart';
import 'add_trip_modal3.dart';
import '../loading.dart';

class AddTripModal4 extends StatefulWidget {
  final TripDraft draft;

  const AddTripModal4({super.key, required this.draft});

  @override
  State<AddTripModal4> createState() => _AddTripModal4State();
}

class _AddTripModal4State extends State<AddTripModal4> {
  bool _isSubmitting = false;

  int? _parseBudget(String? value) {
    if (value == null) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  //완료 버튼 → LoadingScreen 로 이동
  Future<void> _onSubmit(BuildContext context) async {
    if (_isSubmitting) return;

    final draft = widget.draft;

    setState(() => _isSubmitting = true);

    //필수값 체크
    if (draft.country == null ||
        draft.city == null ||
        draft.startDate == null ||
        draft.endDate == null ||
        draft.people == null ||
        draft.purpose == null ||
        draft.stayType == null ||
        draft.transport == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("필수 정보가 누락되었습니다.")),
        );
      }
      setState(() => _isSubmitting = false);
      return;
    }

    final budgetInt = _parseBudget(draft.budget);

    final title = (draft.tripName != null && draft.tripName!.isNotEmpty)
        ? draft.tripName!
        : '${draft.city}, ${draft.country}';

    //Trip 생성에 필요한 data map→ LoadingScreen 으로 넘김
    final tripData = {
      "title": title,
      "country": draft.country,
      "city": draft.city,
      "startDate": DateFormat('yyyy-MM-dd').format(draft.startDate!),
      "endDate": DateFormat('yyyy-MM-dd').format(draft.endDate!),
      "travelerCount": draft.people,
      if (budgetInt != null) "budget": budgetInt,
      "theme": draft.tripName,
      "purpose": draft.purpose,
      "lodgingTypes": [draft.stayType],
      "transportModes": [draft.transport],
    };

    //로딩 화면으로 이동 → Trip 생성은 거기서 실행됨
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripGeneratingScreen(tripData: tripData),
      ),
    );

    setState(() => _isSubmitting = false);
  }

  void _goPrev(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddTripModal3(draft: widget.draft),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;

    final dateRange =
        '${DateFormat('yyyy-MM-dd').format(draft.startDate!)} ~ ${DateFormat('yyyy-MM-dd').format(draft.endDate!)}';
    final destination = '${draft.city}, ${draft.country}';

    return Container(
      width: double.infinity,
      height: 560,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "새 여행 계획",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          //진행바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF2E80EC),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "여행 계획 확인",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _infoRow(label: "목적지", value: destination),
                const SizedBox(height: 22),
                _infoRow(label: "기간", value: dateRange),
                const SizedBox(height: 22),
                _infoRow(label: "인원", value: "${draft.people}명"),
                const SizedBox(height: 22),
                _infoRow(label: "목적", value: draft.purpose ?? "-"),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, size: 24, color: Color(0xFF2E80EC)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "다음 단계\n여행 정보를 바탕으로 맞춤형 체크리스트를 생성해드립니다.",
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),

          //버튼 영역
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _goPrev(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2E80EC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "이전",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2E80EC),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                      _isSubmitting ? null : () => _onSubmit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E80EC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "완료",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Widget _infoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF858585))),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
