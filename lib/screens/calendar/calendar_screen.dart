// calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/trip.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/feature/top_nav_bar.dart';

import 'widgets/add_trip_modal.dart';

class CalendarScreen extends StatefulWidget {
  final Trip? newTrip;

  const CalendarScreen({super.key, this.newTrip});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();

    //기존 여행 목록->GET /trip으로 아마 교체해야댐
    trips = [];

    //새 여행이 전달되었다면 바로 리스트에 추가
    if (widget.newTrip != null) {
      trips.insert(0, widget.newTrip!);
    }
  }

  DateTime getCurrentMonth() =>
      DateTime(selectedDate.year, selectedDate.month, 1);

  List<int?> getDaysInMonth() {
    final firstDay = getCurrentMonth();
    final lastDay = DateTime(firstDay.year, firstDay.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingDayOfWeek = firstDay.weekday % 7;

    final days = <int?>[];

    //앞쪽 빈칸
    for (int i = 0; i < startingDayOfWeek; i++) {
      days.add(null);
    }

    //날짜 채우기
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    return days;
  }

  void navigateMonth(int direction) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + direction,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      '1월', '2월', '3월', '4월', '5월', '6월',
      '7월', '8월', '9월', '10월', '11월', '12월'
    ];

    final dayNames = ['일', '월', '화', '수', '목', '금', '토'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const TopNavBar(title: '여행 캘린더'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //"내 여행 일정" 헤더
            const Text(
              "내 여행 일정",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 4),

            const Text(
              "다가오는 여행을 확인하고 관리하세요",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFABA9A9),
              ),
            ),
            const SizedBox(height: 20),

            //캘린더 카드
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    //월 이동
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => navigateMonth(-1),
                        ),
                        Text(
                          '${selectedDate.year}년 ${monthNames[selectedDate.month - 1]}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => navigateMonth(1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    //요일
                    Row(
                      children: dayNames.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;

                        return Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: index == 0
                                    ? Colors.red
                                    : index == 6
                                    ? Colors.blue
                                    : const Color(0xFF555555),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    //날짜 Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: getDaysInMonth().length,
                      itemBuilder: (context, index) {
                        final day = getDaysInMonth()[index];
                        if (day == null) return const SizedBox();

                        final isToday =
                            day == DateTime.now().day &&
                                selectedDate.month ==
                                    DateTime.now().month &&
                                selectedDate.year ==
                                    DateTime.now().year;

                        return Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday
                                  ? const Color(0xFF2E6BFF)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                  isToday ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),




            //새 여행 추가 카드
            Center(
              child: SizedBox(
                width: 358,
                height: 156,
                child: CustomCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_circle, color: Color(0xFF2E6BFF), size: 40),
                      SizedBox(height: 6),
                      Text(
                        "새 여행 추가",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "새로운 여행을 계획하세요",
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF555555)),
                      ),
                    ],
                  ),
                ),
              ),
            ),



            const SizedBox(height: 20),

            /// ===============================
            /// 여행 카드 리스트
            /// ===============================
            Column(
              children: trips.map((t) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${t.title}  ${t.country}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          t.formattedDateRange,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          t.purpose ?? "-",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '홈',
                isActive: false,
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: '캘린더',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.check_box_outlined,
                activeIcon: Icons.check_box,
                label: '체크리스트',
                isActive: false,
                onTap: () => context.go('/checklist'),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: '설정',
                isActive: false,
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? const Color(0xFF2E6BFF) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
              isActive ? const Color(0xFF2E6BFF) : const Color(0xFF555555),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
