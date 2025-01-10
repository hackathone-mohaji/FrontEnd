import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // 회원가입 API 호출 함수
  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    const String signUpUrl = 'http://182.214.198.108:8888/auth/signup'; // 서버 주소

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
        Navigator.pop(context, 'signup_success'); // 회원가입 성공 메시지 전달
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/camfit1.png',
                    height: MediaQuery
                        .of(context)
                        .padding
                        .top + 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20, width: 16,),
                  buildTextField('이름', nameController),
                  const SizedBox(height: 20, width: 16,),
                  buildTextField('이메일', emailController),
                  const SizedBox(height: 20, width: 16,),
                  buildTextField('비밀번호', passwordController, isPassword: true),
                  const SizedBox(height: 20, width: 16,),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final name = nameController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty &&
                          name.isNotEmpty) {
                        signUp(name, email, password, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('모든 칸을 입력해주세요.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF252525),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }
      ),
    );
  }

  // 공통 텍스트 필드 위젯
  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 14, color: Colors.black87),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.black26,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.white70,
                width: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
