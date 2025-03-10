import 'package:camfit/data/repositories/OotdRepository.dart';

class OotdController {
  final OotdRepository _repository = OotdRepository();

  Map<String, String> fetchOOTD() {
    return _repository.getRandomOOTD();
  }
}
