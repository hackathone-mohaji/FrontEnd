import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/OotdPage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
     OotdPage(),
     ProfilePage(),
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFFFFF),
        selectedItemColor: const Color(0xFF252525),
        unselectedItemColor: const Color(0xFF757575),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 7.5),
              child: Icon(Icons.home, size: 40),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 7.5),
              child: Icon(Icons.person, size: 40),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
