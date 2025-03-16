import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String _baseUrl = 'http://182.214.198.108:8888/auth';

  ///로그인///
  Future<Map<String, dynamic>> login(String email, String password) async {
    final String loginUrl = '$_baseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final decodedBody = utf8.decode(response.bodyBytes);

      final data = jsonDecode(decodedBody);
      if (response.statusCode == 200) {
        //Access Token 저장
        final String accessToken = data['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        return {"success": true, "data": data};
      } else {
        return {"success": false, "error": data['message'] ?? '알 수 없는 오류'};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  ///회원가입///
  Future<Map<String, dynamic>> signUp(
      String name, String email, String password) async {
    const String signUpUrl = '/signup';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$signUpUrl'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        final error = jsonDecode(decodedBody)['message'] ?? '알 수 없는 오류';
        return {"success": false, "error": error};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }


  ///앱에서 액세스 토큰 로드///
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }


  ///토근 재발급///
  Future<bool> reissueToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/tokenModify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      return true;
    } else {
      await logout(); // 실패하면 로그아웃
      return false;
    }
  }


  ///로그 아웃///
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  // API 요청용 (자동 토큰 리프레시 처리)
  Future<http.Response> getAuthorized(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 401) {
      bool refreshed = await reissueToken();

      if (refreshed) {
        // 재발급된 토큰 사용하여 다시 요청
        final newAccessToken = prefs.getString('accessToken')!;
        response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $newAccessToken'},
        );
      } else {
        // 재발급 실패하면 로그아웃 처리
        await logout();
      }
    }
    return response;
  }
}
