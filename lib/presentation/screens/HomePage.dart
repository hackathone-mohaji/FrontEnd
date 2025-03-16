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
    _pageController.jumpToPage(index); // ✅ PageView의 페이지 변경
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController, // ✅ PageView 컨트롤러 연결
        children: const [
          Menu(),
          OotdPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 2, // ✅ 구분선 두께
            color: Colors.grey[300],
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFFFFFFF),
            selectedItemColor: const Color(0xFF252525),
            unselectedItemColor: const Color(0xFF757575),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 7.5),
                  child: Icon(Icons.menu, size: 40),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 7.5),
                  child: Image.asset(
                    'assets/novowel.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 7.5),
                  child: Icon(Icons.person, size: 35, color: Colors.black),
                ),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
