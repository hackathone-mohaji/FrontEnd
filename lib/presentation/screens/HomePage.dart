import 'package:camfit/presentation/screens/Menu.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/OotdPage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Menu(),
          OotdPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8), // 👈 수직 패딩만큼 조정 가능
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, size: 30),
              onPressed: () => _onTabTapped(0),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _onTabTapped(1),
              icon: Image.asset(
                'assets/novowel.png',
                width: 50,
                height: 50,
              ),
            ),
            IconButton(
              onPressed: () => _onTabTapped(2),
              icon: const Icon(Icons.person, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}
