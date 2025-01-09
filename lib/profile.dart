import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final List<File> _photos = [];
  final List<File> _selectedPhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isDeleteMode = false;

  // Animation controller for FAB
  late AnimationController _fabController;
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _addPhotoFromCamera() async {
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
                Navigator.pop(context); // Close dialog
                setState(() {
                  _photos.add(File(photo.path));
                });
              },
              child: const Text("등록"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _addPhotoFromCamera(); // Retry
              },
              child: const Text("재촬영"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _addPhotoFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _photos.add(File(photo.path));
      });
    }
  }

  void _deleteSelectedPhotos() {
    setState(() {
      _photos.removeWhere((photo) => _selectedPhotos.contains(photo));
      _selectedPhotos.clear();
      _isDeleteMode = false;
    });
  }

  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
      _isFabOpen ? _fabController.forward() : _fabController.reverse();
    });
  }

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
            // Profile section
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/profile.png"),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: _deleteSelectedPhotos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                  ),
                  child: const Text("선택한 사진 삭제",
                      style: TextStyle(color: Colors.white)),
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
            // Gallery Button
            Positioned(
              bottom: _isFabOpen ? 210 : 0, // Y축 이동
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
            // Camera Button
            Positioned(
              bottom: _isFabOpen ? 140 : 0, // Y축 이동
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
            // Delete Button
            Positioned(
              bottom: _isFabOpen ? 70 : 0, // Y축 이동
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
            // Main Button
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
}