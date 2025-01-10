import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final List<File> _photos = [];
  final List<File> _selectedPhotos = [];
  final ImagePicker _picker = ImagePicker();
  File? _profilePhoto;
  String? _name;
  String? _profilePhotoUrl;
  bool _isDeleteMode = false;
  bool _isFabOpen = false;
  bool _isCategoryExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // 프로필 데이터 초기화
  }

  // 사용자 이름 및 프로필 이미지 가져오기
  Future<void> _fetchProfileData() async {
    const String profileUrl = 'http://182.214.198.108:8888/auth/profile';

    try {
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _name = data['name'];
          _profilePhotoUrl = data['profilePhotoUrl'];
        });
      } else {
        throw Exception('프로필 데이터를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    }
  }

  // 프로필 사진 변경
  Future<void> _changeProfilePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      const String uploadUrl = 'http://182.214.198.108:8888/auth/profile/photo';

      try {
        final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
        request.files.add(await http.MultipartFile.fromPath(
          'profilePhoto',
          photo.path,
        ));
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final data = jsonDecode(responseData);

          setState(() {
            _profilePhotoUrl = data['profilePhotoUrl'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 사진이 성공적으로 업데이트되었습니다.')),
          );
        } else {
          throw Exception('프로필 사진 업로드에 실패했습니다.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  // 갤러리에서 사진 추가
  Future<void> _addPhotoFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _photos.add(File(photo.path));
      });
    }
  }

  // 카메라로 사진 추가
  Future<void> _addPhotoFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _photos.add(File(photo.path));
      });
    }
  }

  // 선택된 사진 삭제
  void _deleteSelectedPhotos() {
    setState(() {
      _photos.removeWhere((photo) => _selectedPhotos.contains(photo));
      _selectedPhotos.clear();
      _isDeleteMode = false;
    });
  }

  // FAB 토글
  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // 프로필 섹션
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _changeProfilePhoto,
                    child: CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundImage: _profilePhotoUrl != null
                          ? NetworkImage(_profilePhotoUrl!) as ImageProvider
                          : AssetImage("assets/profile.png"),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(
                    _name != null ? "$_name님, 안녕하세요!" : "불러오는 중...",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),
            // 옷장 카테고리 토글 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ExpansionTile(
                title: const Text(
                  "옷장 카테고리",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252525),
                  ),
                ),
                initiallyExpanded: _isCategoryExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isCategoryExpanded = expanded;
                  });
                },
                children: [
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: SingleChildScrollView(
                      child: _buildCategorySection(),
                    ),
                  ),
                ],
              ),
            ),
            // 사진 그리드 섹션
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(photo),
                                  fit: BoxFit.cover,
                                ),
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
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: ElevatedButton(
                  onPressed: _deleteSelectedPhotos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                  ),
                  child: const Text(
                    "선택한 사진 삭제",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 300,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 갤러리 버튼
            Positioned(
              bottom: _isFabOpen ? 210 : 0,
              child: Opacity(
                opacity: _isFabOpen ? 1 : 0,
                child: FloatingActionButton(
                  heroTag: "gallery",
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: _addPhotoFromGallery,
                  child: const Icon(Icons.photo, color: Colors.black87),
                ),
              ),
            ),
            // 카메라 버튼
            Positioned(
              bottom: _isFabOpen ? 140 : 0,
              child: Opacity(
                opacity: _isFabOpen ? 1 : 0,
                child: FloatingActionButton(
                  heroTag: "camera",
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: _addPhotoFromCamera,
                  child: const Icon(Icons.camera_alt, color: Colors.black87),
                ),
              ),
            ),
            // 삭제 버튼
            Positioned(
              bottom: _isFabOpen ? 70 : 0,
              child: Opacity(
                opacity: _isFabOpen ? 1 : 0,
                child: FloatingActionButton(
                  heroTag: "delete",
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: () {
                    setState(() {
                      _isDeleteMode = !_isDeleteMode;
                      _toggleFab();
                    });
                  },
                  child: const Icon(Icons.delete, color: Colors.black87),
                ),
              ),
            ),
            // 메인 버튼
            FloatingActionButton(
              heroTag: "main",
              backgroundColor: Colors.black87,
              shape: const CircleBorder(),
              onPressed: _toggleFab,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory("상의", ["티셔츠", "셔츠", "니트", "후드티"]),
        _buildCategory("하의", ["데님 팬츠", "조거 팬츠", "슬랙스", "반바지", "스커트"]),
        _buildCategory("아우터", ["재킷", "가디건", "패딩", "코트", "점퍼"]),
        _buildCategory("악세사리", ["캡 모자", "비니", "선글라스", "안경", "가방"]),
      ],
    );
  }

  Widget _buildCategory(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF252525),
            ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: items.map((item) {
              return OutlinedButton(
                onPressed: () {
                  debugPrint("$item 선택됨");
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
