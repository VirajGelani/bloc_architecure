import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ShimmerTextWidget extends StatefulWidget {
  final Text child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerTextWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2000),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerTextWidget> createState() => _ShimmerTextWidgetState();
}

class _ShimmerTextWidgetState extends State<ShimmerTextWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 5,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shimmerPosition = _controller.value * 1.5 - 1;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor ?? AppColors.shimmerBase,
                widget.highlightColor ?? AppColors.shimmerHighlight,
                widget.baseColor ?? AppColors.shimmerBase,
              ],
              stops: const [0.1, 0.4, 0.7],
              begin: Alignment(-1.0 + shimmerPosition, 0),
              end: Alignment(1.0 + shimmerPosition, 0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
