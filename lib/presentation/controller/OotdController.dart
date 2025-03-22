import 'dart:io';

import 'package:camfit/data/models/WearDto.dart';
import 'package:camfit/data/repositories/OotdRepository.dart';
import 'package:camfit/data/models/OotdDto.dart';
import 'package:flutter/material.dart';

class OotdController {
  final OotdRepository _repository = OotdRepository();

  ///추천 룩 불러오기///
  Future<OotdDto> fetchOOTD({required BuildContext context}) async {
    return await _repository.getRandomOOTD(context: context);
  }

  ///내 옷장 불러오기///
  Future<List<WearDto>> fetchMyWearList(
      {required BuildContext context, required String category}) async {
    final response =
        await _repository.getMyWearList(context: context, category: category);
    // 컨트롤러에서 데이터를 가공하여 반환
    return response.map((json) => WearDto.fromJson(json)).toList();
  }

  ///추천 룩 불러오기///
  Future<void> addMyWearList(
      {required BuildContext context, required List<File> files}) async {
    await _repository.addMyWearList(context: context, files: files);
  }

  ///옷 삭제 하기///
  Future<void> deleteWear(
      {required BuildContext context, required int wearId}) async {
    await _repository.deleteWear(context: context, wearId: wearId);
  }
}
