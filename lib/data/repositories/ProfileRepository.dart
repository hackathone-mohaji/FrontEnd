import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String _baseUrl = 'http://182.214.198.108:8888';

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    const String profileUrl = '/profile';

    try {
      final String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        return {"success": false, "error": "Access Token 없음. 로그인 필요"};
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$profileUrl'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);


        final data = jsonDecode(decodedBody);
      if (response.statusCode == 200) {

        return {"success": true, "data": data};
      } else {
        return {"success": false, "error": data['message'] ?? '알 수 없는 오류'};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    const String uploadUrl = '/profile';

    try {
      final String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        return {"success": false, "error": "Access Token 없음. 로그인 필요"};
      }

      File file = File(filePath); // 파일 객체 생성
      if (!await file.exists()) {
        return {"success": false, "error": "파일이 존재하지 않습니다."};
      }

      List<int> fileBytes = await file.readAsBytes(); // 파일을 바이너리 데이터로 변환

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$uploadUrl'),
      );
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["Content-Type"] = "multipart/form-data"; //  필수 헤더 추가

      request.files.add(
        await http.MultipartFile.fromBytes(
          'profile', // 서버에서 받는 필드명
          fileBytes,
          filename: filePath.split('/').last, // 파일 이름 유지
        ),
      );
      final response = await request.send();

      final responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(responseData)};
      } else {
        return {"success": false, "error": jsonDecode(responseData)['message']};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}
