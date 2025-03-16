import 'dart:convert';
import 'dart:io';
import 'package:camfit/core/Constants.dart';
import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:camfit/core/HttpClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final HttpClient _httpClient = HttpClient();
  final String _endPoint = '/profile';

  Future<Map<String, dynamic>> fetchProfileData({required BuildContext context}) async {
    try {
      final response = await _httpClient.get(_endPoint, context: context);

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

  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath, {required BuildContext context}) async {
    try {
      final String? accessToken = await AuthRepository().getAccessToken();
      if (accessToken == null) {
        return {"success": false, "error": "Access Token 없음. 로그인 필요"};
      }

      File file = File(filePath);
      if (!await file.exists()) {
        return {"success": false, "error": "파일이 존재하지 않습니다."};
      }

      List<int> fileBytes = await file.readAsBytes();

      final request = http.MultipartRequest('POST', Uri.parse('${Constants.baseUrl}$_endPoint'));
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["Content-Type"] = "multipart/form-data";

      request.files.add(
        http.MultipartFile.fromBytes(
          'profile',
          fileBytes,
          filename: filePath.split('/').last,
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
