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
            child: Image.network(
              wear.wearImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error_outline, color: Colors.grey),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
