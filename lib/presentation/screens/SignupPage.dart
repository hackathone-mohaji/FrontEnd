import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/SignupController.dart';
import 'package:camfit/presentation/widgets/CustomTextField.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final SignupController _signupController = SignupController();

  @override
  void dispose() {
    emailController.dispose();
        super.dispose();
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
                      height: MediaQuery.of(context).padding.top + 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      labelText: '이름',
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                          _signupController.signUp(name, email, password, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('모든 칸을 입력해주세요.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF252525),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const SizedBox(
                        width: 330,
                        child:  Center(
                          child: Text(
                            '회원가입',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                          ),
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
