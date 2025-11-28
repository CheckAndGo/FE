// add_trip_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip_draft.dart';

import 'add_trip_modal2.dart';

class AddTripModal extends StatefulWidget {
  /// 처음 열 때 이미 채워진 draft를 넘기고 싶으면 사용 (보통은 null)
  final TripDraft? initialDraft;

  const AddTripModal({super.key, this.initialDraft});

  @override
  State<AddTripModal> createState() => _AddTripModalState();
}

class _AddTripModalState extends State<AddTripModal> {
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  late TripDraft _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialDraft ?? TripDraft();

    // 기존 draft 값 있으면 복원
    if (_draft.country != null) {
      _countryController.text = _draft.country!;
    }
    if (_draft.city != null) {
      _cityController.text = _draft.city!;
    }
    _startDate = _draft.startDate;
    _endDate = _draft.endDate;
  }

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            const ColorScheme.light(primary: Color(0xFF2E6BFF)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _goNext() {
    if (_countryController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('국가, 도시, 날짜를 모두 입력해주세요.')),
      );
      return;
    }

    final updatedDraft = _draft.copyWith(
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );

    Navigator.pop(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTripModal2(draft: updatedDraft),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 510,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '새 여행 계획',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

          // 진행 바
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: LinearProgressIndicator(
              value: 0.25,
              backgroundColor: const Color(0xffEFEFEF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2E80EC)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 내용
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      '여행지 정보',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('국가'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _countryController,
                      hint: '예: 일본, 프랑스, 미국',
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('도시'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      hint: '예: 도쿄, 파리, 라스베이거스',
                    ),
                    const SizedBox(height: 12),

                    // 날짜
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              _buildLabel('출발일'),
                              const SizedBox(height: 4),
                              _buildDatePickerField(
                                date: _startDate,
                                onTap: () => _selectDate(true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              _buildLabel('도착일'),
                              const SizedBox(height: 4),
                              _buildDatePickerField(
                                date: _endDate,
                                onTap: () => _selectDate(false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          // 확인 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              height: 40,
              width: 350,
              child: ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E80EC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF858585),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
            const BorderSide(color: Color(0xFFBFBFBF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
            const BorderSide(color: Color(0xFFBFBFBF)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
            BorderSide(color: Color(0xFF2E6BFF)),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFBFBFBF)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : '-/-/-',
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
                fontSize: 14,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
