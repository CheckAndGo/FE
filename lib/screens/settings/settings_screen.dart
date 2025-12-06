import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';  // ← 추가됨

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
  String userEmail = "loading...";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? "unknown@example.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(title: '설정', showBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -------------------------------
            // 프로필 섹션
            // -------------------------------
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

                      // ★ 로그인 이메일 표시
                      Text(
                        userEmail,
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

            // -------------------------------
            // 로그아웃 섹션만 유지
            // -------------------------------
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout,
                    size: 18,
                    color: Colors.red[600],
                  ),
                ),
                title: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
                onTap: () {
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
                          onPressed: () async {
                            Navigator.pop(context);

                            // Firebase 로그아웃
                            await FirebaseAuth.instance.signOut();

                            // 로그인 화면으로 이동
                            context.go('/login');
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/settings'),
    );
  }
}
