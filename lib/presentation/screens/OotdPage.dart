import 'package:camfit/presentation/widgets/CustomAppBar.dart';
import 'package:camfit/presentation/widgets/ExpandableTextContainer.dart';
import 'package:camfit/presentation/widgets/FloatingCircleImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:camfit/presentation/widgets/CircleImageWidget.dart';
import 'package:camfit/data/models/OotdDto.dart';

class OotdPage extends StatefulWidget {
  const OotdPage({Key? key}) : super(key: key);

  @override
  _OotdPageState createState() => _OotdPageState();
}

class _OotdPageState extends State<OotdPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  final OotdController _controllerLogic = OotdController();

  final List<OotdDto> _ootdList = []; // ✅ 데이터 저장 리스트
  int _currentPageIndex = 0; // 현재 페이지 인덱스
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pageController = PageController();
    _initializeFirstPage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // 첫 로딩 시 호출
  void _initializeFirstPage() async {
    setState(() => _isLoading = true);
    await _fetchAndAddOotd();
    setState(() => _isLoading = false);
  }

  // API로부터 데이터를 가져와 컬렉션에 추가
  Future<void> _fetchAndAddOotd() async {
    try {
      final fetchedOOTD = await _controllerLogic.fetchOOTD(context: context);
      setState(() {
        _ootdList.add(fetchedOOTD);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로드 중 에러 발생: $e')),
      );
    }
  }

  void _onPageChanged(int index) async {
    _currentPageIndex = index;

    // 데이터가 부족하면 추가 로드
    if (_currentPageIndex >= _ootdList.length - 1 && !_isLoading) {
      setState(() => _isLoading = true);
      await _fetchAndAddOotd();
      setState(() => _isLoading = false);
    }
  }

  void _showCircleModal(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
              Expanded(child: Image.network(imagePath, fit: BoxFit.contain)),
              const SizedBox(height: 10),
              const Text("이미지 상세 정보",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFFFFFFF),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // 데이터가 현재 인덱스에 없으면 로딩을 표시
          if (index >= _ootdList.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final ootd = _ootdList[index];

          // 기존의 Widget 그대로 사용
          return SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Novowel",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF252525)),
                    ),Text(
                      "의 추천",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF252525)),
                    ),
                  ],
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 300,
                  child: Align(
                    alignment: Alignment.center,
                    child: Builder(builder: (context) {
                      List<double> availableSizes = [70, 120, 100, 80];
                      availableSizes.shuffle();

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          if (ootd.outer != null)
                            FloatingCircleImageWidget(
                              size: availableSizes.removeLast(),
                              imagePath: ootd.outer!,
                              initialOffset: const Offset(-50, -60), // 초기 위치
                              onTap: () =>
                                  _showCircleModal(context, ootd.outer!),
                            ),
                          if (ootd.top != null)
                            FloatingCircleImageWidget(
                              size: availableSizes.removeLast(),
                              imagePath: ootd.top!,
                              initialOffset: const Offset(70, -100), // 초기 위치
                              onTap: () => _showCircleModal(context, ootd.top!),
                            ),
                          if (ootd.bottom != null)
                            FloatingCircleImageWidget(
                              size: availableSizes.removeLast(),
                              imagePath: ootd.bottom!,
                              initialOffset: const Offset(-60, 60), // 초기 위치
                              onTap: () =>
                                  _showCircleModal(context, ootd.bottom!),
                            ),
                          if (ootd.shoes != null)
                            /*CircleImageWidget(
                                size: availableSizes.removeLast(),
                                imagePath: ootd.shoes!,
                                onTap: () =>
                                    _showCircleModal(context, ootd.shoes!),
                              ),*/
                            FloatingCircleImageWidget(
                              size: availableSizes.removeLast(),
                              imagePath: ootd.shoes!,
                              initialOffset: const Offset(60, 30), // 초기 위치
                              onTap: () =>
                                  _showCircleModal(context, ootd.shoes!),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
                const Spacer(),
                ExpandableTextContainer(
                  text: ootd.reason ?? "추천 이유 없음",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
