import 'package:flutter/material.dart';
import 'login.dart';
import 'ootd.dart';
import 'profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'camfit',
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/main': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OOTDPage(), // OOTD 페이지
    ProfilePage(), // 프로필 페이지
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // 고정형 네비게이션 바
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: const Color(0xFF252525),
        unselectedItemColor: const Color(0xFF757575),
        showSelectedLabels: false, // 선택된 아이템의 라벨 숨기기
        showUnselectedLabels: false, // 선택되지 않은 아이템의 라벨 숨기기
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 7.5), // 아이콘 중앙 정렬
              child: ImageIcon(
                AssetImage('assets/icon.png'),
                size: 40,
              ),
            ),
            label: '', // 라벨 제거
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 7.5), // 아이콘 중앙 정렬
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            label: '', // 라벨 제거
          ),
        ],
      ),
    );
  }
}
