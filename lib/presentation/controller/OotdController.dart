import 'package:camfit/data/repositories/OotdRepository.dart';
import 'package:camfit/data/models/OotdDto.dart';
import 'package:flutter/material.dart';

class OotdController {
  final OotdRepository _repository = OotdRepository();

  Future<OotdDto> fetchOOTD({required BuildContext context}) async {
    return await _repository.getRandomOOTD(context: context);
  }
}
