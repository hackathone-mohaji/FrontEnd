import 'package:cached_network_image/cached_network_image.dart';
import 'package:camfit/data/models/WearDto.dart';
import 'package:flutter/material.dart';

class WearGrid extends StatelessWidget {
  final List<WearDto> wearList;

  const WearGrid({Key? key, required this.wearList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: wearList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final wear = wearList[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: wear.wearImageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Center( // 👈 에러 발생 시 UI
                child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
              ),
            )
          ),
        );
      },
    );
  }
}
