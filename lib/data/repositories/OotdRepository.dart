import 'dart:math';

class OotdRepository {
  final List<String> topImages = ['assets/top1.png', 'assets/top2.png', 'assets/top3.png'];
  final List<String> bottomImages = ['assets/bottom1.png', 'assets/bottom2.png', 'assets/bottom3.png'];
  final List<String> shoesImages = ['assets/shoes1.png', 'assets/shoes2.png', 'assets/shoes3.png'];
  final List<String> outerImages = ['assets/outer1.png', 'assets/outer2.png', 'assets/outer3.png'];

  Map<String, String> getRandomOOTD() {
    final random = Random();
    return {
      "top": topImages[random.nextInt(topImages.length)],
      "bottom": bottomImages[random.nextInt(bottomImages.length)],
      "shoes": shoesImages[random.nextInt(shoesImages.length)],
      "outer": outerImages[random.nextInt(outerImages.length)],
    };
  }
}
