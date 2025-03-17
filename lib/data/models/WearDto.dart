class WearDto {
  final int wearId;
  final String wearImageUrl;

  WearDto({required this.wearId, required this.wearImageUrl});

  factory WearDto.fromJson(Map<String, dynamic> json) {
    return WearDto(
      wearId: json['wearId'] is int ? json['wearId'] : int.tryParse(json['wearId'].toString()) ?? 0, // 변환은 여기에서 처리
      wearImageUrl: json['wearImageUrl'] ?? '', // null 방지
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wearId': wearId,
      'wearImageUrl': wearImageUrl,
    };
  }
}
