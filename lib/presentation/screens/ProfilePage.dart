import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/ProfileController.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  String? _profilePhotoUrl;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final result = await _controller.fetchProfileData(context: context);
    if (result['success']) {
      setState(() {
        _username = result['data']['username'];
        _profilePhotoUrl = result['data']['imageUrl'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['error']}')),
      );
    }
  }

  Future<void> _updateProfilePhoto() async {
    final result = await _controller.changeProfilePhoto(context);
    if (result['success']) {
      setState(() {
        _profilePhotoUrl = result['data']['imageUrl'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['error']}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _updateProfilePhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePhotoUrl != null
                    ? NetworkImage(_profilePhotoUrl!) as ImageProvider
                    : const AssetImage("assets/profile.png"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _username != null ? "$_username님, 안녕하세요!" : "불러오는 중...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )

          ],
        ),
      ),
    );
  }
}
