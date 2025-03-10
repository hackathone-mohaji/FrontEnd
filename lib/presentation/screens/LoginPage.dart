import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/LoginController.dart';
import 'package:camfit/presentation/widgets/CustomTextField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

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
                      height: MediaQuery.of(context).padding.top + 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: emailController,
                      labelText: '이메일',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      labelText: '비밀번호',
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(context, '/signup');
                            if (result == 'signup_success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('회원가입이 완료되었습니다!')),
                              );
                            }
                          },
                          child: const Text('회원가입', style: TextStyle(color: Colors.black87)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child:
                              const Text('아이디 / 비밀번호 찾기', style: TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isNotEmpty && password.isNotEmpty) {
                          _loginController.login(email, password, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF252525),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Center(
                        child: Text(
                          '로그인',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
