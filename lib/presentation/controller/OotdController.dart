import 'package:camfit/data/repositories/OotdRepository.dart';
import 'package:camfit/data/models/OotdDto.dart';

class OotdController {
  final OotdRepository _repository = OotdRepository();

  Future<OotdDto> fetchOOTD() async {
    return await _repository.getRandomOOTD();
  }
}
