import 'package:cached_network_image/cached_network_image.dart';
import 'package:camfit/data/models/WearDto.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WearGrid extends StatefulWidget {
  final List<WearDto> wearList;
  final String category; // 카테고리 추가
  final Future<void> Function() onWearListUpdated;

  const WearGrid({
    Key? key,
    required this.wearList,
    required this.category,
    required this.onWearListUpdated,
  }) : super(key: key);

  @override
  State<WearGrid> createState() => _WearGridState();
}

class _WearGridState extends State<WearGrid> {
  final OotdController _ootdController = OotdController();

  static final Map<String, int?> _selectedIndexes = {
    'TOP': null,
    'BOTTOM': null,
    'OUTERWEAR': null,
    'SHOES': null,
  }; // 카테고리별 선택된 아이템 인덱스 저장

  final Map<int, bool> _imageLoaded = {}; // 이미지 로딩 상태 저장


  void _handleWearTap(int index) {
    if (_imageLoaded[index] == true) {
      setState(() {
        if (_selectedIndexes[widget.category] == index) {
          _selectedIndexes[widget.category] = null; // 선택 해제
        } else {
          _selectedIndexes[widget.category] = index; // 새 선택 적용
        }
      });
    }
  }

  void _showDeleteDialog(int index) {
    final wear = widget.wearList[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
          ),
          backgroundColor: Colors.black,
          // 배경색 어둡게
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
              onPressed: () async {
                _ootdController.deleteWear(
                    context: context, wearId: wear.wearId);
                await widget.onWearListUpdated();


                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white24, // 배경 반투명
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
  void initState() {
    super.initState();
    _imageLoaded.clear();
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
          onLongPress: () => _showDeleteDialog(index),
          onDoubleTap: () {
            _showDetailDialog(wear.wearImageUrl);
          },
          child: CachedNetworkImage(
            imageUrl: wear.wearImageUrl,
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) {
              if (!_imageLoaded.containsKey(index)) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    _imageLoaded[index] = true;
                  });
                });
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: (_selectedIndexes[widget.category] == index &&
                          _imageLoaded[index] == true)
                      ? Border.all(color: Colors.green, width: 3)
                      : null,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // 로딩 중에도 빈 컨테이너 유지
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
            ),
          ),
        );
      },
    );
  }
}
