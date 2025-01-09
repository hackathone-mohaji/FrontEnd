import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                Container(
                  child: TextField(
                    controller: signUpNameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  width: 400,
                ),
                const SizedBox(height: 15),
                Container(
                  child: TextField(
                    controller: signUpEmailController,
                    decoration: InputDecoration(
                      labelText: '이메일',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  width: 400,
                ),
                const SizedBox(height: 15),
                Container(
                  child: TextField(
                    controller: signUpPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  width: 400,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회원가입이 완료되었습니다.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF252525),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    child: const Text(
                      '회원가입',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    width: 100,
                  ),
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
          Image.asset(
            'assets/camfit1.png',
            height: 200,
          ),
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
          Row(
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
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/main');
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

