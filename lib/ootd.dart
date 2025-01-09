import 'dart:math';

import 'package:flutter/material.dart';

class OOTDPage extends StatefulWidget {
  @override
  _OOTDPageState createState() => _OOTDPageState();
}

class _OOTDPageState extends State<OOTDPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late PageController _pageController;

  // 임시 데이터
  final List<String> _tops = ['assets/top1.png', 'assets/top2.png', 'assets/top3.png'];
  final List<String> _bottoms = ['assets/bottom1.png', 'assets/bottom2.png', 'assets/bottom3.png'];
  final List<String> _shoes = ['assets/shoes1.png', 'assets/shoes2.png', 'assets/shoes3.png'];
  final List<String> _hats = ['assets/hat1.png', 'assets/hat2.png', 'assets/hat3.png'];

  late String _selectedTop;
  late String _selectedBottom;
  late String _selectedShoes;
  late String _selectedHat;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _sizeAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pageController = PageController();
    _randomizeOutfit();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _randomizeOutfit() {
    final random = Random();
    setState(() {
      _selectedTop = _tops[random.nextInt(_tops.length)];
      _selectedBottom = _bottoms[random.nextInt(_bottoms.length)];
      _selectedShoes = _shoes[random.nextInt(_shoes.length)];
      _selectedHat = _hats[random.nextInt(_hats.length)];
    });
  }

  Widget buildCircle(double size, String image) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _sizeAnimation.value,
          child: GestureDetector(
            onTap: () => _showCircleModal(context, image),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCircleModal(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "이미지 상세 정보",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                  ),
                  child: const Text(
                    "닫기",
                    style: TextStyle(color: Colors.black87),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;
          final double circleBaseSize = min(screenHeight, screenWidth) * 0.2;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return SafeArea(
                      child: Column(
                        children: [
                          // 상단 텍스트
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                            child: Column(
                              children: const [
                                Text(
                                  "오늘 뭐 입지?",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF252525),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "OOTD 추천",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF252525),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // 중앙의 원과 이미지 배치
                          SizedBox(
                            height: screenHeight * 0.5,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.translate(
                                  offset: Offset(-circleBaseSize * 0.8, -circleBaseSize * 0.5),
                                  child: buildCircle(circleBaseSize * 0.8, _selectedHat),
                                ),
                                Transform.translate(
                                  offset: Offset(circleBaseSize * 0.8, -circleBaseSize * 0.6),
                                  child: buildCircle(circleBaseSize * 1.2, _selectedTop),
                                ),
                                Transform.translate(
                                  offset: Offset(-circleBaseSize * 0.8, circleBaseSize * 0.8),
                                  child: buildCircle(circleBaseSize, _selectedBottom),
                                ),
                                Transform.translate(
                                  offset: Offset(circleBaseSize * 0.8, circleBaseSize * 0.8),
                                  child: buildCircle(circleBaseSize * 0.9, _selectedShoes),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // 하단 코멘트
                          Container(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: const Center(
                              child: Text(
                                "춥고 습한 날씨 대비를 위해\n보온성과 방수성에 신경 써서 준비하세요! 😊",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    _randomizeOutfit();
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
