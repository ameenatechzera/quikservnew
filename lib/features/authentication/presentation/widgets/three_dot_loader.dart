import 'package:flutter/material.dart';

class ThreeDotLoader extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotLoader({
    super.key,
    this.color = Colors.black,
    this.size = 10,
  });

  @override
  State<ThreeDotLoader> createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        double progress = (_controller.value + index * 0.2) % 1.0;
        double opacity = (progress < 0.5) ? 1.0 : 0.2;

        return Opacity(
          opacity: opacity,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) => _buildDot(index)),
    );
  }
}
