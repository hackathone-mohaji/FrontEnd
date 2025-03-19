import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:camfit/presentation/widgets/GalleryImagePickerWidget.dart';

class UploadOutfitPage extends StatefulWidget {
  const UploadOutfitPage({super.key});

  @override
  State<UploadOutfitPage> createState() => _UploadOutfitPageState();
}

class _UploadOutfitPageState extends State<UploadOutfitPage>
    with SingleTickerProviderStateMixin {
  final OotdController _controller = OotdController();
  List<XFile> _selectedImages = [];
  bool _isUploading = false; // ✅ 업로드 중인지 여부
  double _galleryHeight = 0.5;
  double _minGalleryHeight = 0.055;
  double _maxGalleryHeight = 0.5;
  bool _isGalleryExpanded = true;

  void _onImageSelected(XFile image) {
    setState(() {
      if (_selectedImages.contains(image)) {
        _selectedImages.remove(image); // ✅ 선택된 이미지 터치 시 삭제
      } else {
        _selectedImages.add(image);
      }
    });
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() => _isUploading = true); // ✅ 업로드 시작 시 로딩 표시

    List<File> files = _selectedImages.map((e) => File(e.path)).toList();
    try {
      await _controller.addMyWearList(context: context, files: files);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이미지 업로드 성공!")),
      );

      // ✅ 현재 페이지에서 뒤로 가면서 ProfilePage로 보이게 설정
      Navigator.pop(context, 2);  // 👈 '2'를 반환해서 ProfilePage로 이동하도록 전달
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("업로드 실패: $e")),
      );
    } finally {
      setState(() => _isUploading = false); // ✅ 업로드 완료 후 로딩 해제
    }
  }


  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _galleryHeight -=
          details.primaryDelta! / MediaQuery.of(context).size.height;
      _galleryHeight =
          _galleryHeight.clamp(_minGalleryHeight, _maxGalleryHeight);
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Register"),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: _isUploading
                    ? null
                    : () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                  await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    _onImageSelected(image);
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
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0, // ✅ 간격 없앰
                    mainAxisSpacing: 0,  // ✅ 간격 없앰
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onImageSelected(_selectedImages[index]),
                      child: Image.file(
                        File(_selectedImages[index].path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadImages, // ✅ 업로드 중이면 버튼 비활성화
                icon: _isUploading
                    ? const SizedBox(
                  width: 18, // ✅ 팬딩 크기 축소
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                )
                    : const Icon(Icons.upload, color: Colors.black),
                label: _isUploading
                    ? const Text("업로드 중...")
                    : const Text("업로드"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
              ),

              GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: MediaQuery.of(context).size.height * _galleryHeight,
                  child: GalleryImagePickerWidget(onImageSelected: _onImageSelected),
                ),
              ),
            ],
          ),
        ),
        if (_isUploading)
          ModalBarrier(color: Colors.black54, dismissible: false), // ✅ 업로드 중 다른 동작 방지
      ],
    );
  }
}
