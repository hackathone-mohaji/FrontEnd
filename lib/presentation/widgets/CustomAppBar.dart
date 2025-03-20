import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/MenuPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool centerTitle; // 👈 제목 정렬 옵션 추가 (기본값 false)

  const CustomAppBar({
    Key? key,
    required this.title,
    this.centerTitle = false, // 👈 기본값을 왼쪽 정렬로 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle, // 👈 전달된 값에 따라 중앙 정렬 여부 결정
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
