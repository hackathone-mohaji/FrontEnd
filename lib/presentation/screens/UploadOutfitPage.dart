import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';

class UploadOutfitPage  extends StatefulWidget {
  const UploadOutfitPage({super.key});

  @override
  State<UploadOutfitPage> createState() => _UploadOutfitPageState();
}

class _UploadOutfitPageState extends State<UploadOutfitPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("해당 부분에 갤러리 추가해서 옷 이미지 등록")
            ],
          ),
        ));
  }
}
