import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camfit/data/repositories/ProfileRepository.dart';

class ProfileController {
  final ProfileRepository _repository = ProfileRepository();
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>> fetchProfileData({required BuildContext context}) async {
    return await _repository.fetchProfileData(context: context);
  }

  Future<Map<String, dynamic>> changeProfilePhoto(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      return await _repository.uploadProfilePhoto(photo.path,context: context);
    } else {
      return {"success": false, "error": "No photo selected."};
    }
  }
}
