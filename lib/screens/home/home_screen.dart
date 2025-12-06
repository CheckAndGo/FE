/// HomeScreen - 메인 홈 화면
///
/// [주요 기능]
/// - 사용자의 여행 목록을 카드 형태로 표시
/// - 각 여행의 D-day, 진행률, 날짜 정보 표시
/// - 여행 카드 클릭 시 해당 여행의 체크리스트 화면으로 이동
/// - '새 여행 계획하기' 버튼으로 AddTripModal 호출
///
/// [API 연동]
/// - TripService.getTrips()로 여행 목록 조회 (실제 API 연동)
/// - 로딩, 에러, 빈 목록 상태 처리
///
/// [사용 위젯]
/// - TopNavBar: 상단 앱바
/// - CustomCard: 여행 카드 및 새 여행 추가 카드
/// - CustomButton: '시작하기' 버튼
/// - BottomNavBar: 하단 네비게이션 바
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/trip.dart';
import '../../models/trip_response.dart';
import '../../services/trip_service.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/base/custom_button.dart';
import '../calendar/widgets/add_trip_modal.dart';

// =========================================
// HomeScreen (메인)
// =========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 여행 목록 데이터
  List<Trip> trips = [];

  /// 로딩 상태 플래그
  bool isLoading = true;

  /// 에러 메시지 (에러 발생 시에만 값 존재)
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  /// 여행 목록을 API에서 불러오는 메서드
  ///
  /// [동작]
  /// 1. 로딩 상태 활성화
  /// 2. TripService를 통해 여행 목록 조회
  /// 3. 성공 시 trips 리스트 업데이트, 실패 시 에러 메시지 표시
  Future<void> _loadTrips() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await TripService.fetchTrips();

      setState(() {
        trips = response.items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = '여행 목록을 불러오는데 실패했습니다.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const TopNavBar(title: 'Check&Go'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              '안녕하세요! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '다가오는 여행을 준비해보세요',
              style: TextStyle(fontSize: 16, color: Color(0xFF6F6F6F)),
            ),
            const SizedBox(height: 20),

            const Text(
              '다음 여행 일정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (errorMessage != null)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _loadTrips,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              )
            else if (trips.isNotEmpty)
                ...trips.map((trip) => _buildTripCard(trip))
              else
                _buildEmptyState(),

            const SizedBox(height: 60),

            _buildAddTripCard(),

            const SizedBox(height: 24),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/'),
    );
  }

  /// ---------------------------------------------
  /// 여행 카드 UI
  /// ---------------------------------------------
  Widget _buildTripCard(Trip trip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        onTap: () => context.go('/checklist/${trip.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(trip.flagEmoji ?? '', style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${trip.country} ${trip.city}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E80EC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'D-${trip.dDay}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E80EC),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.formattedDateRange,
                      style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                    ),
                    Text(
                      trip.tripDuration,
                      style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('준비 완료',
                    style: TextStyle(fontSize: 14, color: Color(0xFF555555))),
                Text(
                  '${trip.progressPercentage}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E80EC),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: trip.progress,
                backgroundColor: Colors.grey.shade200,
                color: const Color(0xFF2E80EC),
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '체크리스트 보기',
                  style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------------------------
  /// 여행 없음 UI
  /// ---------------------------------------------
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.flight_takeoff, size: 40, color: Color(0xFFCCCCCC)),
        ),
        const SizedBox(height: 20),
        const Text(
          '아직 일정이 없어요',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6F6F6F),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '아래 버튼으로 첫 일정을 만들어보세요',
          style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
        ),
      ],
    );
  }

  // 새 여행 계획하기 카드
  Widget _buildAddTripCard() {
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF2E80EC).withOpacity(0.7),
          const Color(0xFF009A6B).withOpacity(0.4),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '새 여행 계획하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '목적지와 일정을 추가해보세요',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),

          //여행 생성 후 → 홈 목록 즉시 갱신 → 로딩 → 체크리스트 이동
          CustomButton(
            text: '시작하기',
            variant: ButtonVariant.ghost,
            size: ButtonSize.md,
            onPressed: () async {
              final Trip? newTrip = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddTripModal(),
              );

              if (newTrip != null) {
                await _loadTrips();  // ← 홈 자동 갱신

                if (!mounted) return;

                context.go('/loading', extra: newTrip);
              }
            },
          ),
        ],
      ),
    );
  }
}
