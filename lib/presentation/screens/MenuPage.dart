import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<void> _logout() async {
    await AuthRepository().logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 🔥 버튼 배경색 흰색
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기
                    side: const BorderSide(color: Colors.redAccent, width: 2), // 🔥 테두리 색상 redAccent
                  ),
                ),
                onPressed: _logout,
                child: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent), // 🔥 글씨 색상 redAccent
                ),
              )
            ],
          ),
        ));
  }
}
