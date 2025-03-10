// import 'dart:math';
// import 'package:flutter/material.dart';

// class OOTDPage extends StatefulWidget {
//       const OOTDPage({Key? key}) : super(key: key);
//   @override
//   _OOTDPageState createState() => _OOTDPageState();
// }

// class _OOTDPageState extends State<OOTDPage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _sizeAnimation;
//   late PageController _pageController;

//   // 카테고리별 데이터
//   final List<String> topImages = ['assets/top1.png', 'assets/top2.png', 'assets/top3.png'];
//   final List<String> bottomImages = ['assets/bottom1.png', 'assets/bottom2.png', 'assets/bottom3.png'];
//   final List<String> shoesImages = ['assets/shoes1.png', 'assets/shoes2.png', 'assets/shoes3.png'];
//   final List<String> outerImages = ['assets/outer1.png', 'assets/outer2.png', 'assets/outer3.png'];

//   late String _selectedTop;
//   late String _selectedBottom;
//   late String _selectedShoes;
//   late String _selectedOuter;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);

//     _sizeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     _pageController = PageController();
//     _initializePage(); // 첫 페이지 초기화
//   }

//   void _initializePage() {
//     final random = Random();
//     setState(() {
//       _selectedTop = topImages[random.nextInt(topImages.length)];
//       _selectedBottom = bottomImages[random.nextInt(bottomImages.length)];
//       _selectedShoes = shoesImages[random.nextInt(shoesImages.length)];
//       _selectedOuter = outerImages[random.nextInt(outerImages.length)];
//     });
//   }

//   Widget buildCircle(double size, String image) {
//     return GestureDetector(
//       onTap: () => _showCircleModal(context, image),
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white70,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 2,
//             ),
//           ],
//           image: DecorationImage(
//             image: AssetImage(image),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }

//   void _showCircleModal(BuildContext context, String imagePath) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Container(
//             width: 300,
//             height: 300,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: Image.asset(
//                     imagePath,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "이미지 상세 정보",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white70,
//                   ),
//                   child: const Text(
//                     "닫기",
//                     style: TextStyle(color: Colors.black87),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFFFF),
//       body: PageView.builder(
//         controller: _pageController,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           return SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//                   child: Column(
//                     children: const [
//                       Text(
//                         "오늘 뭐 입지?",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.normal,
//                           color: Color(0xFF252525),
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         "OOTD 추천",
//                         style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF252525),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 SizedBox(
//                   height: 300,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Transform.translate(
//                           offset: const Offset(-50, -60),
//                           child: buildCircle(70, _selectedOuter),
//                         ),
//                         Transform.translate(
//                           offset: const Offset(70, -100),
//                           child: buildCircle(120, _selectedTop),
//                         ),
//                         Transform.translate(
//                           offset: const Offset(-60, 60),
//                           child: buildCircle(100, _selectedBottom),
//                         ),
//                         Transform.translate(
//                           offset: const Offset(60, 30),
//                           child: buildCircle(80, _selectedShoes),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: const EdgeInsets.only(bottom: 20.0),
//                   margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                   child: Text(
//                     "캠핏의 코멘트 \n 이 조합은 오늘의 날씨와 분위기에 딱 맞는 스타일입니다!",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       color: Color(0xFF252525),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         physics: const BouncingScrollPhysics(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:camfit/presentation/widgets/CircleImageWidget.dart';

class OotdPage extends StatefulWidget {
  const OotdPage({Key? key}) : super(key: key);

  @override
  _OotdPageState createState() => _OotdPageState();
}

class _OotdPageState extends State<OotdPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  late Map<String, String> _selectedOOTD;

  final OotdController _controllerLogic = OotdController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pageController = PageController();
    _initializePage();
  }

  void _initializePage() {
    setState(() {
      _selectedOOTD = _controllerLogic.fetchOOTD();
    });
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
                const Text(
                  "이미지 상세 정보",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white70),
                  child:
                      const Text("닫기", style: TextStyle(color: Colors.black87)),
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
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child:
                      Column(children:
                          const [
                            Text("오늘 뭐 입지?", 
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
              SizedBox(
                height: 300,
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(-50, -60),
                        child: CircleImageWidget(
                          size: 70,
                          imagePath: _selectedOOTD["outer"]!,
                          onTap: () => _showCircleModal(context, _selectedOOTD["outer"]!),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(70, -100),
                        child: CircleImageWidget(
                          size: 120,
                          imagePath: _selectedOOTD["top"]!,
                          onTap: () => _showCircleModal(context, _selectedOOTD["top"]!),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-60, 60),
                        child: CircleImageWidget(
                          size: 100,
                          imagePath: _selectedOOTD["bottom"]!,
                          onTap: () => _showCircleModal(context, _selectedOOTD["bottom"]!),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(60, 30),
                        child: CircleImageWidget(
                          size: 80,
                          imagePath: _selectedOOTD["shoes"]!,
                          onTap: () => _showCircleModal(context, _selectedOOTD["shoes"]!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "캠핏의 코멘트 \n 이 조합은 오늘의 날씨와 분위기에 딱 맞는 스타일입니다!",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF252525),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      physics: const BouncingScrollPhysics(),
    ),
  );
}
}