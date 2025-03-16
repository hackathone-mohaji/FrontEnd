import 'package:flutter/material.dart';

class ExpandableTextContainer extends StatefulWidget {
  final String text;

  const ExpandableTextContainer({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextContainerState createState() => _ExpandableTextContainerState();
}

class _ExpandableTextContainerState extends State<ExpandableTextContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFullTextDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF252525),
          ),
          textAlign: TextAlign.center,
          maxLines: 4, // ✅ 기본적으로 2줄까지만 표시
          overflow: TextOverflow.ellipsis, // ✅ 넘치는 경우 "..."으로 생략
        ),
      ),
    );
  }

  // ✅ 다이얼로그로 전체 텍스트 표시
  void _showFullTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("룩 설명"),
          content: SingleChildScrollView(
            child: Text(widget.text), // 전체 텍스트 표시
          ),
        );
      },
    );
  }
}
