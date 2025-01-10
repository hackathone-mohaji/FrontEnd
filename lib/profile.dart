import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String? _profilePhotoUrl;
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch the profile data when the widget initializes
  }

  // Fetch profile data
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
          _username = data['username'];
          _profilePhotoUrl = data['imageUrl'];
        });
      } else {
        throw Exception('Failed to load profile data.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Change profile photo
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
            _profilePhotoUrl = data['imageUrl'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated successfully.')),
          );
        } else {
          throw Exception('Failed to upload profile photo.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _changeProfilePhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePhotoUrl != null
                    ? NetworkImage(_profilePhotoUrl!) as ImageProvider
                    : AssetImage("assets/profile.png"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _username != null ? "$_username님, 안녕하세요!" : "불러오는 중...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
