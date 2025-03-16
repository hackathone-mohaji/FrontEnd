class WearDto {
  final int wearId;
  final String wearImageUrl;

  WearDto({required this.wearId, required this.wearImageUrl});

  factory WearDto.fromJson(Map<String, dynamic> json) {
    return WearDto(
      wearId: json['wearId'],
      wearImageUrl: json['wearImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wearId': wearId,
      'wearImageUrl': wearImageUrl,
    };
  }
}
