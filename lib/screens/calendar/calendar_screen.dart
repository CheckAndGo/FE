import 'package:flutter/material.dart';
import '../../models/calendar_trip.dart';
import '../../services/trip_service.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import 'widgets/add_trip_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  //현재 보고 있는 월 정보
  DateTime selectedDate = DateTime.now();

  //해당 월의 여행 일정 리스트
  List<CalendarTrip> trips = [];

  //로딩 스피너 표시 여부
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCalendarTrips(); //화면 시작 시 여행 목록 불러오기
  }

  //년도랑 월 기준으로 캘린더 여행 리스트 불러오기
  Future<void> _loadCalendarTrips() async {
    final year = selectedDate.year;
    final month = selectedDate.month;

    print("🔄 [CalendarScreen] Load → $year-$month");

    setState(() => isLoading = true);

    try {
      final items = await TripService.fetchCalendarTrips(
        year: year,
        month: month,
      );

      print("📌 Loaded trips = ${items.length}");

      setState(() => trips = items);
    } catch (e) {
      print("❌ Calendar load error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  //달력 넘어가는 코드 (중요x)
  void navigateMonth(int direction) async {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + direction,
        1,
      );
    });

    await _loadCalendarTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: const TopNavBar(title: "여행 캘린더"),

      //메인 화면 스크롤 영역
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //화면 상단 타이틀
            const Text("내 여행 일정",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),

            const Text("다가오는 여행을 확인하고 관리하세요",
                style: TextStyle(fontSize: 12, color: Color(0xFF888888))),

            const SizedBox(height: 20),

            //달력 UI
            _buildCalendarView(),

            const SizedBox(height: 20),

            //새로운 여행 추가 버튼
            _buildAddTripButton(),

            const SizedBox(height: 20),

            //여행 카드 리스트
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: trips.map(_buildTripCard).toList()),

            const SizedBox(height: 60),
          ],
        ),
      ),

      //화면 하단 네비게이션 바
      bottomNavigationBar: const BottomNavBar(currentPath: '/calendar'),
    );
  }

  //달력 렌더링
  Widget _buildCalendarView() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            //년 월 이동 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //이전달
                IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => navigateMonth(-1)),

                //---년 --월
                Text(
                  "${selectedDate.year}년 ${selectedDate.month}월",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                //다음달
                IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => navigateMonth(1)),
              ],
            ),

            const SizedBox(height: 12),

            //날짜 칸 렌더링 1~31
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7),
              itemCount: _daysInMonth().length,
              itemBuilder: (context, index) {
                final day = _daysInMonth()[index];
                if (day == null) return const SizedBox();
                return Center(
                  child: Text(
                    "$day",
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //📌 현재 달의 "빈칸 + 날짜 리스트" 생성

  List<int?> _daysInMonth() {
    final first = DateTime(selectedDate.year, selectedDate.month, 1);
    final last = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final empty = first.weekday % 7;
    final days = <int?>[];

    //달력 앞부분 빈칸 채우기
    for (int i = 0; i < empty; i++) days.add(null);

    //날짜 채우기
    for (int d = 1; d <= last.day; d++) days.add(d);

    return days;
  }

  //"새 여행 추가" 카드
  Widget _buildAddTripButton() {
    return GestureDetector(
      onTap: () async {
        final newTrip = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTripModal(),
        );

        //여행을 생성한 경우 목록 재로딩
        if (newTrip != null) {
          print("🎉 New trip → reload calendar");
          await _loadCalendarTrips();
        }
      },
      child: SizedBox(
        width: 358,
        height: 156,
        child: CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle, color: Color(0xFF2E6BFF), size: 40),
              SizedBox(height: 6),
              Text("새 여행 추가",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("새로운 여행을 계획하세요",
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
            ],
          ),
        ),
      ),
    );
  }

  //도시 + 나라 → 날짜 → 제목 → 목적(태그)

  Widget _buildTripCard(CalendarTrip t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //도시 + 나라
              Text("${t.city} ${t.country}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111))),
              const SizedBox(height: 6),

              //여행 날짜
              Text(
                t.formattedDateRange,
                style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 8),

              //여행 제목
              Text(
                t.title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              //목적 태그
              Text(
                t.purposeTag ?? "-",
                style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
