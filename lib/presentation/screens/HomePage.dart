import 'package:camfit/presentation/screens/UploadOutfitPage.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/OotdPage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _pages = [
    const UploadOutfitPage(),
    const OotdPage(),
    const ProfilePage(),
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_a_photo, size: 34),
            title: const Text("upload"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              'assets/novowel.png',
              width: 54,
              height: 54,
            ),
            title: const Text("ootd"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person, size: 35),
            title: const Text("profile"),
            selectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
