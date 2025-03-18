import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';

class GalleryImagePickerWidget extends StatefulWidget {
  final Function(XFile) onImageSelected;

  const GalleryImagePickerWidget({super.key, required this.onImageSelected});

  @override
  State<GalleryImagePickerWidget> createState() => _GalleryImagePickerWidgetState();
}

class _GalleryImagePickerWidgetState extends State<GalleryImagePickerWidget> {
  final ScrollController _scrollController = ScrollController();
  List<AssetEntity> _galleryImages = [];
  Map<int, File?> _imageCache = {}; // ✅ 이미지 캐싱 추가
  bool _isLoading = false;
  int _currentPage = 0;
  static const int _pageSize = 30;

  @override
  void initState() {
    super.initState();
    _requestGalleryPermission();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// ✅ 갤러리 권한 요청
  Future<void> _requestGalleryPermission() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.hasAccess) {
      _loadGalleryImages();
    }
  }

  /// ✅ 페이징으로 이미지 가져오기
  Future<void> _loadGalleryImages() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);

    if (albums.isNotEmpty) {
      final List<AssetEntity> images = await albums.first.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );

      for (int i = 0; i < images.length; i++) {
        _cacheImage(i + (_currentPage * _pageSize), images[i]); // ✅ 미리 캐싱
      }

      setState(() {
        _galleryImages.addAll(images);
        _currentPage++;
        _isLoading = false;
      });
    }
  }

  /// ✅ 개별 이미지 캐싱
  Future<void> _cacheImage(int index, AssetEntity entity) async {
    final File? file = await entity.file;
    if (file != null) {
      setState(() {
        _imageCache[index] = file;
      });
    }
  }

  /// ✅ 스크롤할 때 추가 이미지 로드
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _loadGalleryImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text("갤러리에서 이미지 선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: _galleryImages.isEmpty
                ? const Center(child: Text("갤러리에 이미지가 없습니다."))
                : GridView.builder(
              controller: _scrollController,
              itemCount: _galleryImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // ✅ 3열로 정렬
                crossAxisSpacing: 0, // ✅ 가로 간격 제거
                mainAxisSpacing: 0, // ✅ 세로 간격 제거
              ),
              itemBuilder: (context, index) {
                final File? file = _imageCache[index]; // ✅ 캐싱된 이미지 가져오기

                if (file == null) {
                  return const SizedBox(); // ✅ 로딩 중에는 빈 컨테이너 (로딩 UI 제거)
                }

                return GestureDetector(
                  onTap: () {
                    widget.onImageSelected(XFile(file.path));
                  },
                  child: Image.file(
                    file,
                    fit: BoxFit.cover, // ✅ 이미지가 빈 공간 없이 꽉 차도록 설정
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
