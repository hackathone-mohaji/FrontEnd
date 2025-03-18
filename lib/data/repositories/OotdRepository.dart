import 'dart:convert';
import 'dart:io';
import 'package:camfit/core/HttpClient.dart';
import 'package:camfit/data/models/OotdDto.dart';
import 'package:camfit/data/models/WearDto.dart';
import 'package:flutter/material.dart';

class OotdRepository {
  final HttpClient _httpClient = HttpClient();
  final String _endPoint = '/wear';

  /// 랜덤 조합 추천 ///
  Future<OotdDto> getRandomOOTD({required BuildContext context}) async {
    try {
      final response = await _httpClient.patch(_endPoint, context: context);

      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = jsonDecode(decodedBody);

      if (response.statusCode == 200) {
        return OotdDto.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? "OOTD 데이터 요청 실패");
      }
    } catch (e) {
      throw Exception("OOTD 데이터를 불러오는 중 오류 발생: $e");
    }
  }

  /// 내 옷 목록 불러오기 ///
  Future<List<dynamic>> getMyWearList({
    required BuildContext context,
    required String category
  }) async {
    final response = await _httpClient.get('$_endPoint?category=$category',
        context: context);

    final decodedBody = utf8.decode(response.bodyBytes);
    debugPrint("Decoded Response: $decodedBody"); // 디버깅용 출력

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);

      if (!jsonResponse.containsKey('wears') || jsonResponse['wears'] == null) {
        return [];
      }

      return jsonResponse['wears'] as List<dynamic>;
    } else {
      final errorMessage =
          jsonDecode(decodedBody)['message'] ?? '옷 데이터 불러오기 실패';
      throw Exception(errorMessage);
    }
  }



  /// 내 옷 등록하기 ///
  Future<void> addMyWearList({
    required BuildContext context, required List<File> files}) async {
    final response = await _httpClient.post(_endPoint,files: files,
        context: context);

    final decodedBody = utf8.decode(response.bodyBytes);
    debugPrint("Decoded Response: $decodedBody"); // 디버깅용 출력

    if (response.statusCode != 200) {
      final errorMessage = jsonDecode(decodedBody)['message'] ?? '옷 데이터 등록 실패';
      throw Exception(errorMessage);
    }
  }




}
