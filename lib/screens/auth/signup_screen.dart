import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/base/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    //입력값 검증
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 정보를 입력해주세요.')),
      );
      return;
    }

    //비밀번호 일치 확인
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //Firebase Auth 계정 생성
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        //Firebase Auth 프로필 이름 업데이트
        await user.updateDisplayName(_nameController.text.trim());

        //Firestore에 유저 정보 저장 (백엔드 규칙: users/{uid})
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'id': user.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'emailVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
        });


        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입 성공!')),
          );
          //홈으로 이동
          context.go('/');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '회원가입에 실패했습니다.';

      if (e.code == 'weak-password') {
        errorMessage = '비밀번호가 너무 약합니다. 6자리 이상 설정해주세요.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = '이미 사용 중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '유효하지 않은 이메일 형식입니다.';
      } else if (e.code == 'permission-denied') {
        errorMessage = '데이터 저장 권한이 없습니다. (Firestore 규칙 확인 필요)';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(errorMessage), backgroundColor: Colors.redAccent),
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
                    padding: const EdgeInsets.only(top: 12, bottom: 32, left: 10, right: 10),
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
                        //이름 입력
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            '이름',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _nameController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '이름을 입력하세요',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Icon(Icons.person_outline, color: Colors.grey[400], size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        //이메일 입력
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
                        const SizedBox(height: 8),
                        SizedBox(
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
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

                        const SizedBox(height: 16),

                        //비밀번호 입력
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
                        const SizedBox(height: 8),
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

                        const SizedBox(height: 16),

                        //비밀번호 확인 입력
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            '비밀번호 확인',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '비밀번호를 다시 입력하세요',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        //회원가입 버튼
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                          child: SizedBox(
                            width: 296,
                            height: 48,
                            child: CustomButton(
                              text: '회원가입 완료',
                              fullWidth: true,
                              onPressed: _handleSignup,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  //하단 로그인
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '이미 계정이 있으신가요?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => context.go('/auth/login'),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}