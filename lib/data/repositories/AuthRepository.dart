import 'dart:convert';
import 'package:http/http.dart' as http;

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

      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {"success": false, "error": jsonDecode(response.body)['error'] ?? '알 수 없는 오류'};
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

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        final error = jsonDecode(response.body)['error'] ?? '알 수 없는 오류';
        return {"success": false, "error": error};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
  
}
