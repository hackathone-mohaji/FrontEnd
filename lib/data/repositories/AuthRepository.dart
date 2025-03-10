import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String _baseUrl = 'http://182.214.198.108:8888/auth';

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


   Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
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
  
}
