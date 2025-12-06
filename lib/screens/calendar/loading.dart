import 'package:flutter/material.dart';
import '../../../models/trip.dart';
import '../../../services/trip_service.dart';
import 'package:go_router/go_router.dart';

class TripGeneratingScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const TripGeneratingScreen({super.key, required this.tripData});

  @override
  State<TripGeneratingScreen> createState() => _TripGeneratingScreenState();
}

class _TripGeneratingScreenState extends State<TripGeneratingScreen> {
  @override
  void initState() {
    super.initState();
    _generateTrip();
  }

  Future<void> _generateTrip() async {
    try {
      //여행 생성
      final Trip trip = await TripService.createTrip(widget.tripData);

      if (!mounted) return;

      //모든 bottomSheet / modal 닫기 -> 혹시나 오류 발생시 모달 닫기 위해 넣어둠
      Navigator.popUntil(context, (route) => route.isFirst);

      //방금 생성된 여행의 체크리스트 화면으로 이동
      context.go('/checklist/${trip.id}');

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('생성 실패: $e')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 55,
              height: 55,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "맞춤 체크리스트 생성 중...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Opacity(
              opacity: 0.6,
              child: Text(
                "Tip: 보조배터리는 기내에 가지고 타야 해요.",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
