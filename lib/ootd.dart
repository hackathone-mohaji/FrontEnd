import 'package:flutter/material.dart';

class OOTDPage extends StatefulWidget {
  @override
  _OOTDPageState createState() => _OOTDPageState();
}

class _OOTDPageState extends State<OOTDPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showCircleModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 라운딩 추가
          ),
          child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.0), // 라운딩 추가
            ),
            child: Center(
              child: const Text(
                "상세 정보",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF252525),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCircle(double size) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _sizeAnimation.value,
            child: GestureDetector(
              onTap: () => showCircleModal(context),
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
                ),
              ),
            ),
          );
        },
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 텍스트
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 32),
                        child: Text(
                          "오늘 뭐 입지?",
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF252525),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          "OOTD 추천",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF252525),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 중앙 원
            SizedBox(
              height: 600, // 원 배치 영역의 높이
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 원 1
                    Transform.translate(
                      offset: Offset(-50, -60), // 왼쪽 위
                      child: buildCircle(70),
                    ),
                    // 원 2
                    Transform.translate(
                      offset: Offset(70, -100), // 오른쪽 위
                      child: buildCircle(120),
                    ),
                    // 원 3
                    Transform.translate(
                      offset: Offset(-60, 60), // 왼쪽 아래
                      child: buildCircle(100),
                    ),
                    // 원 4
                    Transform.translate(
                      offset: Offset(60, 30), // 오른쪽 아래
                      child: buildCircle(80),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
