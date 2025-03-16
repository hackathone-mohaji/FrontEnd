import 'dart:convert';
import 'package:camfit/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';
/// 로그인된 사용자의 api 요청///
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;
  HttpClient._internal();

  final String baseUrl = Constants.baseUrl;

  Future<http.Response> get(String endpoint, {required BuildContext context}) async {
    return _sendRequest('GET', endpoint, context: context);
  }

  Future<http.Response> post(String endpoint, {dynamic body, required BuildContext context}) async {
    return _sendRequest('POST', endpoint, body: body, context: context);
  }

  Future<http.Response> patch(String endpoint, {dynamic body, required BuildContext context}) async {
    return _sendRequest('PATCH', endpoint, body: body, context: context);
  }

  Future<http.Response> _sendRequest(
      String method,
      String endpoint, {
        dynamic body,
        required BuildContext context,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    var response = await _makeRequest(method, endpoint, token: accessToken, body: body);

    if (_isTokenExpired(response)) {
      bool refreshed = await AuthRepository().reissueToken();
      if (refreshed) {
        accessToken = prefs.getString('accessToken')!;
        response = await _makeRequest(method, endpoint, token: accessToken, body: body);
      } else {
        await AuthRepository().logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
        throw Exception("세션이 만료되었습니다. 다시 로그인해주세요.");
      }
    }

    return response;
  }

  Future<http.Response> _makeRequest(String method, String endpoint, {String? token, dynamic body}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl$endpoint');

    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PATCH':
        return await http.patch(uri, headers: headers, body: jsonEncode(body));
      default:
        throw UnsupportedError("지원되지 않는 HTTP 메소드입니다.");
    }
  }

  bool _isTokenExpired(http.Response response) {
    return response.statusCode == 401 || response.body.contains('EXPIRED_ACCESS_TOKEN');
  }
}
