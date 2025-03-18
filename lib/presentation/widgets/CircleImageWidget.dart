import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  final double size;
  final String imagePath;
  final VoidCallback onTap;

  const CircleImageWidget({
    Key? key,
    required this.size,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
            ),
          ],
          image: DecorationImage(
            image: CachedNetworkImageProvider(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
