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
  OotdDto _selectedOOTD = OotdDto(
    outer: null,
    top: null,
    bottom: null,
    shoes: null,
    reason: "추천 이유 없음",
    combinationId: 0,
    bookmarked: false,
    totalCount: 0,
  );

  bool _isLoading = true;

  final OotdController _controllerLogic = OotdController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..repeat(reverse: true);

    _pageController = PageController();
    _initializePage();
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ 애니메이션 컨트롤러 해제
    _pageController.dispose(); // ✅ 페이지 컨트롤러 해제
    super.dispose();
  }

  void _initializePage() async {
    setState(() {
      _isLoading = true; // ✅ API 호출 전 로딩 상태 활성화
    });

    final fetchedOOTD = await _controllerLogic.fetchOOTD(); // ✅ 비동기 호출

    setState(() {
      _selectedOOTD = fetchedOOTD; // 데이터가 도착한 후 상태 업데이트
      _isLoading = false; // ✅ 데이터가 도착하면 로딩 상태 해제
    });
  }


  void _onPageChanged(int index) {
    _initializePage();
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
                  child: Image.network(
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
        onPageChanged: _onPageChanged,
        physics: _isLoading
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: [
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
                _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : SizedBox(
                  height: 300,
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_selectedOOTD?.outer != null)
                          Transform.translate(
                            offset: const Offset(-50, -60),
                            child: CircleImageWidget(
                              size: 70,
                              imagePath: _selectedOOTD!.outer!,
                              onTap: () =>
                                  _showCircleModal(
                                      context, _selectedOOTD!.outer!),
                            ),
                          ),
                        if (_selectedOOTD?.top != null)
                          Transform.translate(
                            offset: const Offset(70, -100),
                            child: CircleImageWidget(
                              size: 120,
                              imagePath: _selectedOOTD!.top!,
                              onTap: () =>
                                  _showCircleModal(
                                      context, _selectedOOTD!.top!),
                            ),
                          ),
                        if (_selectedOOTD?.bottom != null)
                          Transform.translate(
                            offset: const Offset(-60, 60),
                            child: CircleImageWidget(
                              size: 100,
                              imagePath: _selectedOOTD!.bottom!,
                              onTap: () =>
                                  _showCircleModal(
                                      context, _selectedOOTD!.bottom!),
                            ),
                          ),
                        if (_selectedOOTD?.shoes != null)
                          Transform.translate(
                            offset: const Offset(60, 30),
                            child: CircleImageWidget(
                              size: 80,
                              imagePath: _selectedOOTD!.shoes!,
                              onTap: () =>
                                  _showCircleModal(
                                      context, _selectedOOTD!.shoes!),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    _selectedOOTD?.reason ?? "추천 이유 없음", //  DTO에서 코멘트 가져오기
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
      ),
    );
  }
}
