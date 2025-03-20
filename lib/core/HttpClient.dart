import 'dart:convert';
import 'dart:io';
import 'package:camfit/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

/// 로그인된 사용자의 api 요청///
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;
  HttpClient._internal();

  final String baseUrl = Constants.baseUrl;

  Future<http.Response> get(String endpoint, {required BuildContext context}) async {
    return _sendRequest('GET', endpoint, context: context);
  }

  Future<http.Response> post(String endpoint, {dynamic body, List<File>? files, required BuildContext context}) async {
    return _sendRequest('POST', endpoint, body: body, files: files, context: context);
  }

  Future<http.Response> patch(String endpoint, {dynamic body, List<File>? files, required BuildContext context}) async {
    return _sendRequest('PATCH', endpoint, body: body, files: files, context: context);
  }

  Future<http.Response> _sendRequest(
      String method,
      String endpoint, {
        dynamic body,
        List<File>? files,
        required BuildContext context,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

        print("[DEBUG] 기존 accessToken: $accessToken");
    var response = (files != null && files.isNotEmpty)
        ? await _makeMultipartRequest(method, endpoint, token: accessToken, body: body, files: files)
        : await _makeRequest(method, endpoint, token: accessToken, body: body);

    if (_isTokenExpired(response)) {
      print("[DEBUG] 토큰 만료 감지! 리프레시 시도...");
      bool refreshed = await AuthRepository().reissueToken();
      if (refreshed) {
        prefs.reload(); // SharedPreferences 최신화
        accessToken = prefs.getString('accessToken');
        print("[DEBUG] 새로운 accessToken: $accessToken");
        if (accessToken == null || accessToken.isEmpty) {
          print("[ERROR] 리프레시 성공 후에도 accessToken이 없음!");
          throw Exception("리프레시 토큰으로 새 액세스 토큰을 받았으나 저장되지 않았습니다.");
        }

        response = (files != null && files.isNotEmpty)
            ? await _makeMultipartRequest(method, endpoint, token: accessToken, body: body, files: files)
            : await _makeRequest(method, endpoint, token: accessToken, body: body);
      } else {
        print("[ERROR] 리프레시 토큰 갱신 실패! 로그아웃 진행...");
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

  Future<http.Response> _makeMultipartRequest(
      String method, String endpoint, {
        String? token,
        dynamic body,
        required List<File> files,
      }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest(method, uri);

    // Authorization 헤더 추가
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // JSON 데이터 추가 (옵션)
    if (body != null) {
      request.fields['json'] = jsonEncode(body);
    }

    // 파일 추가
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath(
        'files', // 서버에서 받을 필드명 (백엔드와 협의 필요)
        file.path,
        filename: basename(file.path),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  bool _isTokenExpired(http.Response response) {
    return response.statusCode == 401 || response.body.contains('EXPIRED_ACCESS_TOKEN');
  }
}
