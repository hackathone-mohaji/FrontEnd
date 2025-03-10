import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final String _baseUrl = 'http://182.214.198.108:8888/auth';

  Future<Map<String, dynamic>> fetchProfileData() async {
    const String profileUrl = '/profile';

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$profileUrl'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {"success": false, "error": 'Failed to load profile data.'};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    const String uploadUrl = '/profile/photo';

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$uploadUrl'));
      request.files.add(await http.MultipartFile.fromPath('profilePhoto', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return {"success": true, "data": jsonDecode(responseData)};
      } else {
        return {"success": false, "error": 'Failed to upload profile photo.'};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}
