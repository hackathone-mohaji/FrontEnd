import 'package:camfit/data/models/WearDto.dart';
import 'package:camfit/presentation/widgets/CustomAppBar.dart';
import 'package:camfit/presentation/widgets/WearGrid.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/controller/ProfileController.dart';
import 'package:camfit/presentation/controller/OotdController.dart';

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
  String _selectedCategory = 'TOP';

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
      final wearList = await _ootdController.fetchMyWearList(
          context: context, category: _selectedCategory);
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title:Text("Profile")),
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _categoryButton('TOP'),
                    _categoryButton('BOTTOM'),
                    _categoryButton('OUTERWEAR'),
                    _categoryButton('SHOES'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.47,
                child: WearGrid(wearList: _wearList),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
            _loadMyWearList();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedCategory == category ? Colors.black : Colors.grey[300],
          foregroundColor:
              _selectedCategory == category ? Colors.white : Colors.black,
        ),
        child: Text(category),
      ),
    );
  }
}
