import 'package:cached_network_image/cached_network_image.dart';
import 'package:camfit/data/models/WearDto.dart';
import 'package:flutter/material.dart';

class WearGrid extends StatefulWidget {
  final List<WearDto> wearList;
  final String category; // 카테고리 추가

  const WearGrid({Key? key, required this.wearList, required this.category}) : super(key: key);

  @override
  State<WearGrid> createState() => _WearGridState();
}

class _WearGridState extends State<WearGrid> {
  static final Map<String, int?> _selectedIndexes = {
    'TOP': null,
    'BOTTOM': null,
    'OUTERWEAR': null,
    'SHOES': null,
  }; // 카테고리별 선택된 아이템 인덱스 저장

  void _handleWearTap(int index) {
    setState(() {
      if (_selectedIndexes[widget.category] == index) {
        _selectedIndexes[widget.category] = null; // 선택 해제
      } else {
        _selectedIndexes[widget.category] = index; // 새 선택 적용
      }
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
          ),
          backgroundColor: Colors.black, // 배경색 어둡게
          title: const Text(
            '이미지 삭제',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '더이상 조합으로 추천되지 않습니다. 삭제할까요?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white24, // 배경 반투명
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('삭제', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.wearList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final wear = widget.wearList[index];
        return GestureDetector(
          onTap: () {
            _handleWearTap(index);
          },
          onLongPress: _showDeleteDialog,
          onDoubleTap: () {
            _showDetailDialog(wear.wearImageUrl);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
              border: _selectedIndexes[widget.category] == index
                  ? Border.all(color: Colors.green, width: 3)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: wear.wearImageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
