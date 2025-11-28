import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../../models/trip.dart';
import '../../../models/trip_draft.dart';
import 'add_trip_modal3.dart';

class AddTripModal4 extends StatelessWidget {
  final TripDraft draft;

  const AddTripModal4({super.key, required this.draft});

  int? _parseBudget(String? value) {
    if (value == null) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  Future<void> _createTrip(BuildContext context) async {
    if (draft.country == null ||
        draft.city == null ||
        draft.startDate == null ||
        draft.endDate == null ||
        draft.people == null ||
        draft.purpose == null ||
        draft.stayType == null ||
        draft.transport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 정보가 누락되었습니다. 다시 확인해주세요.')),
      );
      return;
    }

    final uri = Uri.parse(
        'http://10.0.2.2:5001/checkandgo-e1045/asia-northeast3/api/trips');

    final budgetInt = _parseBudget(draft.budget);

    final title =
    (draft.tripName != null && draft.tripName!.isNotEmpty)
        ? draft.tripName!
        : '${draft.city}, ${draft.country}';

    final body = {
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

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final Trip newTrip = Trip.fromJson(decoded["trip"]);

        Navigator.popUntil(context, (route) => route.isFirst);
        context.go('/calendar', extra: newTrip);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('여행이 생성되었어요!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('생성 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }

  void _goPrev(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddTripModal3(draft: draft),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = draft.startDate!;
    final end = draft.endDate!;
    final dateRange =
        '${DateFormat('yyyy-MM-dd').format(start)} ~ ${DateFormat('yyyy-MM-dd').format(end)}';

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
          //헤더
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

          //진행 바
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

          //다음
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
                children: [
                  const Icon(Icons.info_outline,
                      size: 24, color: Color(0xFF2E80EC)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "다음 단계",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "여행 정보를 바탕으로 맞춤형 체크리스트를 생성해드립니다.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),


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
                      onPressed: () => _createTrip(context),
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
        Text(
          label,
          style:
          const TextStyle(fontSize: 14, color: Color(0xFF858585)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
