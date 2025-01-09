import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<File> _photos = [];
  bool _isDeleteMode = false;
  final ImagePicker _picker = ImagePicker();

  // 사진 등록
  Future<void> _addPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("사진 등록"),
          content: const Text("사진을 등록하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                setState(() {
                  _photos.add(File(photo.path));
                });
              },
              child: const Text("등록"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                _addPhoto(); // 다시 촬영
              },
              child: const Text("재촬영"),
            ),
          ],
        ),
      );
    }
  }

  // 사진 삭제
  void _deleteSelectedPhotos() {
    setState(() {
      _photos.removeWhere((photo) => _selectedPhotos.contains(photo));
      _selectedPhotos.clear();
      _isDeleteMode = false;
    });
  }

  // 선택된 사진 리스트
  final List<File> _selectedPhotos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(color: Color(0xFF252525)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 프로필 정보
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "qwer1234님, 안녕하세요!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),
            // 옷장 관리와 등록/삭제
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "옷장 관리",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252525),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _addPhoto,
                        child: const Text(
                          "등록",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF252525),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isDeleteMode = !_isDeleteMode;
                          });
                        },
                        child: const Text(
                          "삭제",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 옷장 관리 그리드
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    final isSelected = _selectedPhotos.contains(photo);
                    return GestureDetector(
                      onTap: () {
                        if (_isDeleteMode) {
                          setState(() {
                            if (isSelected) {
                              _selectedPhotos.remove(photo);
                            } else {
                              _selectedPhotos.add(photo);
                            }
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(photo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (_isDeleteMode && isSelected)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isDeleteMode)
              ElevatedButton(
                onPressed: _deleteSelectedPhotos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
                child: const Text("선택한 사진 삭제",
                style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
