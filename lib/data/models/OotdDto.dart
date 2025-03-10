class OotdDto {
  final String? top;
  final String? bottom;
  final String? shoes;
  final String? outer;
  final int combinationId;
  final String reason;
  final bool bookmarked;
  final int totalCount;

  OotdDto({
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.outer,
    required this.combinationId,
    required this.reason,
    required this.bookmarked,
    required this.totalCount,
  });

  // JSON에서 DTO로 변환
  factory OotdDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> wears = json['wears'] ?? [];

    return OotdDto(
      top: _getWearByCategory(wears, "TOP"),
      bottom: _getWearByCategory(wears, "BOTTOM"),
      shoes: _getWearByCategory(wears, "SHOES"),
      outer: _getWearByCategory(wears, "OUTERWEAR"),
      combinationId: json["combinationId"] ?? 0,
      reason: json["reason"] ?? "추천 이유 없음",
      bookmarked: json["bookmarked"] ?? false,
      totalCount: json["totalCount"] ?? 0,
    );
  }

  // 특정 카테고리의 의류 URL 가져오기
  static String? _getWearByCategory(List<dynamic> wears, String category) {
    for (var wear in wears) {
      if (wear['category'] == category) {
        return wear['wearImageUrl'];
      }
    }
    return null; // 해당 카테고리의 아이템이 없을 경우 null 반환
  }
}
