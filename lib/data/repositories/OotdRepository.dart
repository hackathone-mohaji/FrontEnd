import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camfit/data/models/OotdDto.dart';


class OotdRepository {
  final String _baseUrl = 'http://182.214.198.108:8888/wear';

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<OotdDto> getRandomOOTD() async {
    try {
      final String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access Token 없음. 로그인 필요");
      }

      final response = await http.patch(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = jsonDecode(decodedBody);

      if (response.statusCode == 200) {
        return OotdDto.fromJson(responseData); // ✅ DTO 반환
      } else {
        throw Exception(responseData['message'] ?? "OOTD 데이터 요청 실패");
      }
    } catch (e) {
      throw Exception("OOTD 데이터를 불러오는 중 오류 발생: $e");
    }
  }
}
