import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FloatingCircleImageWidget extends StatefulWidget {
  final double size;
  final String imagePath;
  final VoidCallback onTap;
  final Offset initialOffset; // 시작 위치

  const FloatingCircleImageWidget({
    Key? key,
    required this.size,
    required this.imagePath,
    required this.onTap,
    required this.initialOffset,
  }) : super(key: key);

  @override
  _FloatingCircleImageWidgetState createState() =>
      _FloatingCircleImageWidgetState();
}

class _FloatingCircleImageWidgetState extends State<FloatingCircleImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true); // 반복 애니메이션

    final random = Random();
    _animationX = Tween<double>(
      begin: widget.initialOffset.dx,
      end: widget.initialOffset.dx + random.nextInt(40) - 20, // 랜덤한 x 축 이동
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animationY = Tween<double>(
      begin: widget.initialOffset.dy,
      end: widget.initialOffset.dy + random.nextInt(40) - 20, // 랜덤한 y 축 이동
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animationX.value, _animationY.value),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.size,
              height: widget.size,
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
                  image: CachedNetworkImageProvider(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
