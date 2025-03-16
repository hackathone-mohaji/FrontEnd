import 'dart:convert';
import 'package:camfit/core/HttpClient.dart';
import 'package:camfit/data/models/OotdDto.dart';
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
  Future<List<OotdDto>> getMyWearList({required BuildContext context}) async {
    final response = await _httpClient.get(_endPoint, context: context);

    final decodedBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(decodedBody);
      return data.map((json) => OotdDto.fromJson(json)).toList();
    } else {
      final errorMessage = jsonDecode(decodedBody)['message'] ?? '옷 데이터 불러오기 실패';
      throw Exception(errorMessage);
    }
  }
}
