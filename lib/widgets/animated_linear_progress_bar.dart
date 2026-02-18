import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedLinearProgressBar extends StatefulWidget {
  final double progress;
  final double? height;
  final Color? backgroundColor;
  final Color? valueColor;
  final double? borderRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool animateFromZero;
  final bool useDashboardColors;

  const AnimatedLinearProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
    this.backgroundColor,
    this.valueColor,
    this.borderRadius = 4,
    this.animationDuration,
    this.animationCurve,
    this.animateFromZero = true,
    this.useDashboardColors = false,
  });

  @override
  State<AnimatedLinearProgressBar> createState() =>
      _AnimatedLinearProgressBarState();
}

class _AnimatedLinearProgressBarState extends State<AnimatedLinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _previousProgress = widget.animateFromZero ? 0.0 : widget.progress;
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        Tween<double>(
          begin: _previousProgress,
          end: widget.progress.clamp(0.0, 1.0),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.animationCurve ?? Curves.easeOut,
          ),
        );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedLinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.animateFromZero != widget.animateFromZero) {
      if (widget.animateFromZero && !oldWidget.animateFromZero) {
        _previousProgress = 0.0;
      } else {
        _previousProgress = _animation.value;
      }
      _animation =
          Tween<double>(
            begin: _previousProgress,
            end: widget.progress.clamp(0.0, 1.0),
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: widget.animationCurve ?? Curves.easeOut,
            ),
          );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor = widget.useDashboardColors
        ? AppColors.white
        : AppColors.white;

    final Color defaultValueColor = widget.useDashboardColors
        ? AppColors.black
        : AppColors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return LinearProgressIndicator(
            value: _animation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            minHeight: widget.height ?? 4,
            backgroundColor: widget.backgroundColor ?? defaultBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.valueColor ?? defaultValueColor,
            ),
          );
        },
      ),
    );
  }
}
