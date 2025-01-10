import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 회원가입 API 호출 함수
  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    const String signUpUrl = 'http://localhost:8080/signup'; // 로컬 서버 주소

    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pop(context); // 다이얼로그 닫기
      } else {
        final error = jsonDecode(response.body)['error'] ?? '알 수 없는 오류';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  // 로그인 API 호출 함수
  Future<void> login(String email, String password, BuildContext context) async {
    const String loginUrl = 'http://localhost:8080/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공!')),
        );
        Navigator.pushReplacementNamed(context, '/main'); // 메인 페이지로 이동
      } else {
        final error = jsonDecode(response.body)['error'] ?? '알 수 없는 오류';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }

  // 회원가입 다이얼로그
  void showSignUpDialog(BuildContext context) {
    TextEditingController signUpNameController = TextEditingController();
    TextEditingController signUpEmailController = TextEditingController();
    TextEditingController signUpPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252525),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: signUpNameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: signUpEmailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: signUpPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final name = signUpNameController.text.trim();
                    final email = signUpEmailController.text.trim();
                    final password = signUpPasswordController.text.trim();

                    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                      signUp(name, email, password, context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
                      );
                    }
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/camfit1.png', height: 200),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const SizedBox(),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: ' 이메일',
                labelStyle: TextStyle(fontSize: 14, color: Colors.black87),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.black26, // 포커스 상태에서의 테두리 색상
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.white70, // 비활성 상태에서의 테두리 색상
                    width: 1.0,
                  ),
                ),
              ),
            ),
            width: 450,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: ' 비밀번호',
                labelStyle: TextStyle(fontSize: 14, color: Colors.black87),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.black26, // 포커스 상태에서의 테두리 색상
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.white70, // 비활성 상태에서의 테두리 색상
                    width: 1.0,
                  ),
                ),
              ),
            ),
            width: 450,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => showSignUpDialog(context),
                  child: const Text(
                      '회원가입',
                      style: TextStyle(color: Colors.black87)
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                      '아이디 / 비밀번호 찾기',
                      style: TextStyle(color: Colors.black87)
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isNotEmpty && password.isNotEmpty) {
                login(email, password, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF252525),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Center(
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              width: 450,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Login(),
    routes: {
      '/main': (context) => const MainScreen(),
    },
  ));
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text('메인 페이지'),
      ),
    );
  }
}
