import 'package:flutter/material.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';

class SettingSection {
  final String title;
  final List<SettingItem> items;

  SettingSection({required this.title, required this.items});
}

class SettingItem {
  final String id;
  final String title;
  final String? description;
  final String type; // 'toggle', 'navigation', 'action'
  final IconData icon;
  bool? value;
  final VoidCallback? action;

  SettingItem({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.icon,
    this.value,
    this.action,
  });
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool darkMode = false;
  bool autoSync = true;

  late List<SettingSection> settingSections;

  @override
  void initState() {
    super.initState();
    _buildSettingSections();
  }

  void _buildSettingSections() {
    settingSections = [
      SettingSection(
        title: '알림 설정',
        items: [
          SettingItem(
            id: 'push',
            title: '푸시 알림',
            description: '여행 일정 및 체크리스트 알림을 받습니다',
            type: 'toggle',
            icon: Icons.notifications_outlined,
            value: pushNotifications,
            action: () =>
                setState(() => pushNotifications = !pushNotifications),
          ),
          SettingItem(
            id: 'email',
            title: '이메일 알림',
            description: '중요한 업데이트를 이메일로 받습니다',
            type: 'toggle',
            icon: Icons.email_outlined,
            value: emailNotifications,
            action: () =>
                setState(() => emailNotifications = !emailNotifications),
          ),
        ],
      ),
      SettingSection(
        title: '앱 설정',
        items: [
          SettingItem(
            id: 'dark',
            title: '다크 모드',
            description: '어두운 테마를 사용합니다',
            type: 'toggle',
            icon: Icons.dark_mode_outlined,
            value: darkMode,
            action: () => setState(() => darkMode = !darkMode),
          ),
          SettingItem(
            id: 'sync',
            title: '자동 동기화',
            description: '데이터를 자동으로 동기화합니다',
            type: 'toggle',
            icon: Icons.sync,
            value: autoSync,
            action: () => setState(() => autoSync = !autoSync),
          ),
        ],
      ),
      SettingSection(
        title: '계정',
        items: [
          SettingItem(
            id: 'profile',
            title: '프로필 편집',
            description: '개인정보를 수정합니다',
            type: 'navigation',
            icon: Icons.person_outline,
          ),
          SettingItem(
            id: 'backup',
            title: '데이터 백업',
            description: '여행 데이터를 백업합니다',
            type: 'navigation',
            icon: Icons.cloud_outlined,
          ),
          SettingItem(
            id: 'export',
            title: '데이터 내보내기',
            description: '여행 기록을 내보냅니다',
            type: 'navigation',
            icon: Icons.download_outlined,
          ),
        ],
      ),
      SettingSection(
        title: '지원',
        items: [
          SettingItem(
            id: 'help',
            title: '도움말',
            description: '자주 묻는 질문을 확인합니다',
            type: 'navigation',
            icon: Icons.help_outline,
          ),
          SettingItem(
            id: 'contact',
            title: '문의하기',
            description: '개발팀에 문의합니다',
            type: 'navigation',
            icon: Icons.support_agent,
          ),
          SettingItem(
            id: 'version',
            title: '버전 정보',
            description: 'v1.0.0',
            type: 'navigation',
            icon: Icons.info_outline,
          ),
        ],
      ),
      SettingSection(
        title: '기타',
        items: [
          SettingItem(
            id: 'logout',
            title: '로그아웃',
            type: 'action',
            icon: Icons.logout,
            action: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // 로그아웃 로직
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget renderToggle(bool value, VoidCallback onChange) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF2E6BFF) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(title: '설정', showBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //프로필 섹션
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E6BFF), Color(0xFF1E40AF)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '여행자',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'traveler@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            //설정 섹션들
            ...settingSections.asMap().entries.map((entry) {
              final section = entry.value;
              final isLast = entry.key == settingSections.length - 1;

              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: section.items.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 64,
                            color: Colors.grey[100],
                          ),
                          itemBuilder: (context, index) {
                            final item = section.items[index];
                            final isLogout = item.id == 'logout';

                            return InkWell(
                              onTap: item.action,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isLogout
                                            ? Colors.red[50]
                                            : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        item.icon,
                                        size: 18,
                                        color: isLogout
                                            ? Colors.red[600]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: isLogout
                                                  ? Colors.red[600]
                                                  : Colors.black87,
                                            ),
                                          ),
                                          if (item.description != null)
                                            const SizedBox(height: 2),
                                          if (item.description != null)
                                            Text(
                                              item.description!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (item.type == 'toggle' &&
                                        item.value != null &&
                                        item.action != null)
                                      renderToggle(item.value!, item.action!),
                                    if (item.type == 'navigation')
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey[400],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) const SizedBox(height: 16),
                ],
              );
            }).toList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/settings'),
    );
  }
}
