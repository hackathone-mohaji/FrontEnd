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
  Future<List<WearDto>> fetchMyWearList({required BuildContext context,required String category}) async {
    final response = await _repository.getMyWearList(context: context,category: category);
    return response
        .map((data) => WearDto.fromJson(data.toJson()))
        .toList();
  }
}
