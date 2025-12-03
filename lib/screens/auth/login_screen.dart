import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/base/custom_button.dart';
import '../../services/trip_service.dart';
import '../../services/checklist_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //로그인 처리 함수
  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //Firebase Auth 로그인 시도
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        String? idToken = await user.getIdToken();
        debugPrint('Generated Access Token: $idToken');

        // API 서비스에 토큰 설정
        if (idToken != null) {
          TripService.setAuthToken(idToken);
          // ChecklistService는 인스턴스 기반이므로 추후 Provider 등으로 관리 필요
          debugPrint('토큰이 TripService에 설정되었습니다.');
        }

        //Firestore에서 유저 정보 읽기 (표준 경로: users/{uid})
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          debugPrint('User Data from Firestore: ${userDoc.data()}');
        } else {
          debugPrint('Firestore 데이터 없음 (users 컬렉션에 문서가 없음)');
        }


        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인이 되었어요')),
          );

          //홈으로 이동
          context.go('/');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '로그인에 실패했습니다.';

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = '이메일 또는 비밀번호가 일치하지 않습니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '유효하지 않은 이메일 형식입니다.';
      } else if (e.code == 'permission-denied') {
        errorMessage = '데이터 접근 권한이 없습니다. (Firestore 규칙 확인 필요)';
      } else if (e.code == 'too-many-requests') {
        errorMessage = '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E80EC).withOpacity(0.7), //피그마 파랑
              const Color(0xFF009A6B).withOpacity(0.4), //피그마 녹색
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //로고
                  Container(
                    width: 124,
                    height: 124,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
                    child: Image.asset(
                      'lib/pics/cg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //타이틀
                  const Text(
                    'Check&Go',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '여행 준비의 새로운 시작',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),

                  //흰색 박스
                  Container(
                    width: 356,
                    height: 475,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //이메일 라벨
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            '이메일',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        //이메일 입력창
                        SizedBox(
                          width: 336,
                          height: 48,
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '이메일을 입력하세요',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Icon(Icons.email_outlined, color: Colors.grey[400], size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        //비밀번호 라벨
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            '비밀번호',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        //비밀번호 입력창
                        SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '비밀번호를 입력하세요',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Icon(Icons.remove_red_eye_outlined, color: Colors.grey[400], size: 20),
                            ),
                          ),
                        ),

                        const Spacer(),

                        //로그인 버튼
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                          text: '로그인하기',
                          fullWidth: true,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  //하단 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '아직 계정이 없으신가요?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => context.go('/auth/signup'),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}