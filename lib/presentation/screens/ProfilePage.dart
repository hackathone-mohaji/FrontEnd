import 'package:camfit/data/models/WearDto.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/ProfileController.dart';
import 'package:camfit/presentation/controller/OotdController.dart';
import 'package:camfit/data/models/OotdDto.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  final OotdController _ootdController = OotdController();

  String? _profilePhotoUrl;
  String? _username;
  List<WearDto> _wearList = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadMyWearList();
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

  Future<void> _loadMyWearList() async {
    try {
      final wearList = await _ootdController.fetchMyWearList(context: context);
      setState(() {
        _wearList = wearList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('옷 데이터를 불러오는 중 오류 발생: $e')),
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _wearList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // ✅ 가로 3개씩
                  crossAxisSpacing: 16, // 가로 간격
                  mainAxisSpacing: 16, // 세로 간격
                  childAspectRatio: 1, // ✅ 정사각형으로 표시
                ),
                itemBuilder: (context, index) {
                  final wear = _wearList[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // ✅ 옅은 회색 배경 추가
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        wear.wearImageUrl, // OotdDto의 imageUrl 필드를 사용한다고 가정
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child:
                                Icon(Icons.error_outline, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
