import 'dart:io';
import 'dart:typed_data';
import 'package:camfit/presentation/screens/HomePage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:camfit/presentation/widgets/GalleryImagePickerWidget.dart';

class UploadOutfitPage extends StatefulWidget {
  const UploadOutfitPage({super.key});

  @override
  State<UploadOutfitPage> createState() => _UploadOutfitPageState();
}

class _UploadOutfitPageState extends State<UploadOutfitPage> with SingleTickerProviderStateMixin {
  final OotdController _controller = OotdController();
  List<AssetEntity> _selectedImages = [];
  Map<String, Uint8List?> _thumbnailCache = {};
  bool _isUploading = false;
  double _galleryHeight = 0.5;
  double _minGalleryHeight = 0.055;
  double _maxGalleryHeight = 0.5;
  bool _isGalleryExpanded = true;
  bool _isFabVisible = true;

  void _onImageSelected(AssetEntity entity) async {
    Uint8List? thumbnail = await entity.thumbnailDataWithSize(const ThumbnailSize(200, 200));

    setState(() {
      if (_selectedImages.contains(entity)) {
        _selectedImages.remove(entity);
        _thumbnailCache.remove(entity.id);
      } else {
        _selectedImages.insert(0, entity);
        _thumbnailCache[entity.id] = thumbnail;
      }
    });
  }

  Future<List<File>> _getOriginalFiles() async {
    List<File> files = [];
    for (var entity in _selectedImages) {
      File? file = await entity.file;
      if (file != null) {
        files.add(file);
      }
    }
    return files;
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;
    setState(() => _isUploading = true);

    List<File> files = await _getOriginalFiles();
    try {
      await _controller.addMyWearList(context: context, files: files);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이미지 업로드 성공!")),
      );
    //todo: 프로필 페이지로 이동
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("업로드 실패: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _galleryHeight -= details.primaryDelta! / MediaQuery.of(context).size.height;
      _galleryHeight = _galleryHeight.clamp(_minGalleryHeight, _maxGalleryHeight);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      if (_galleryHeight > 0.3) {
        _galleryHeight = _maxGalleryHeight;
        _isGalleryExpanded = true;
      } else {
        _galleryHeight = _minGalleryHeight;
        _isGalleryExpanded = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _isUploading
                ? null
                : () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                _onImageSelected(await PhotoManager.editor.saveImageWithPath(image.path));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: _selectedImages.isEmpty
                ? const Center(child: Text("이미지를 선택하세요."))
                : GridView.builder(
              itemCount: _selectedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                AssetEntity entity = _selectedImages[index];
                Uint8List? thumbnail = _thumbnailCache[entity.id];
                return GestureDetector(
                  onTap: () => _onImageSelected(entity),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: thumbnail != null
                        ? Image.memory(thumbnail, fit: BoxFit.cover)
                        : Container(color: Colors.grey[300]),
                  ),
                );
              },
            ),
          ),


          GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: MediaQuery.of(context).size.height * _galleryHeight,
              child: GalleryImagePickerWidget(
                onImageSelected: _onImageSelected,
                selectedImages: _selectedImages,
                onScrollStateChanged: (bool isStopped) {
                  setState(() => _isFabVisible = isStopped);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0, // 🔥 스크롤 상태에 따라 투명도 변경
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: _isUploading ? null : _uploadImages,
          backgroundColor: Colors.white,
          elevation: 5, // 버튼 그림자
          shape: const CircleBorder(),
            child: _isUploading
              ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
              : const Icon(Icons.upload, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


}