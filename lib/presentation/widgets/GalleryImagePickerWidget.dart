import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImagePickerWidget extends StatefulWidget {
  final Function(AssetEntity) onImageSelected;
  final List<AssetEntity> selectedImages;
  final Function(bool) onScrollStateChanged;

  const GalleryImagePickerWidget({super.key, required this.onImageSelected, required this.selectedImages, required this.onScrollStateChanged,});

  @override
  State<GalleryImagePickerWidget> createState() => _GalleryImagePickerWidgetState();
}

class _GalleryImagePickerWidgetState extends State<GalleryImagePickerWidget> {
  final ScrollController _scrollController = ScrollController();
  List<AssetEntity> _galleryImages = [];
  Map<int, Uint8List?> _thumbnailCache = {};
  bool _isLoading = false;
  int _currentPage = 0;
  static const int _pageSize = 30;
  Timer? _scrollStopTimer;


  @override
  void initState() {
    super.initState();
    _requestGalleryPermission();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollStopTimer?.cancel();
    super.dispose();
  }

  Future<void> _requestGalleryPermission() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.hasAccess) {
      _loadGalleryImages();
    }
  }

  Future<void> _loadGalleryImages() async {
    if (_isLoading) return;

    _isLoading = true;
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);

    if (albums.isNotEmpty) {
      final List<AssetEntity> images = await albums.first.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );

      _currentPage++;

      for (int i = 0; i < images.length; i++) {
        int index = i + ((_currentPage - 1) * _pageSize);
        images[i].thumbnailDataWithSize(const ThumbnailSize(200, 200)).then((data) {
          if (data != null) {
            _thumbnailCache[index] = data;
          }
        });
      }

      setState(() {
        _galleryImages.addAll(images);
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }

  void _onScroll() {
    widget.onScrollStateChanged(false);

    _scrollStopTimer?.cancel();
    _scrollStopTimer = Timer(const Duration(milliseconds: 900), () {
      if (_scrollController.position.userScrollDirection == ScrollDirection.idle) {
        widget.onScrollStateChanged(true);
      }
    });

    if (_isLoading) return;
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
          const SizedBox(height: 11),
          const Text("갤러리에서 이미지 선택", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 11),
          Expanded(
            child: _galleryImages.isEmpty
                ? const Center(child: Text("갤러리에 이미지가 없습니다."))
                : GridView.builder(
              controller: _scrollController,
              itemCount: _galleryImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: (context, index) {
                AssetEntity entity = _galleryImages[index];
                bool isSelected = widget.selectedImages.contains(entity);
                return GestureDetector(
                  onTap: () => widget.onImageSelected(entity),
                  child: Opacity(
                    opacity: isSelected ? 0.4 : 1.0,
                    child: _thumbnailCache.containsKey(index) && _thumbnailCache[index] != null
                        ? Image.memory(
                      _thumbnailCache[index]!,
                      fit: BoxFit.cover,
                    )
                        : FutureBuilder<Uint8List?>(
                      future: entity.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          _thumbnailCache[index] = snapshot.data;
                          return Image.memory(snapshot.data!, fit: BoxFit.cover);
                        } else {
                          return Container(color: Colors.grey[300]);
                        }
                      },
                    ),
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
