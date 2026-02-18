import 'package:flutter/material.dart';

import '../utils/extension.dart';
import 'bounceable.dart';

class CustomTap extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final bool isBounceable;
  final bool isHaptic;

  const CustomTap({
    super.key,
    required this.onTap,
    required this.child,
    this.isBounceable = true,
    this.isHaptic = false,
  });

  void _handleTap() {
    if (isHaptic) {
      goHaptic;
    }
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return isBounceable
        ? Bounceable(onTap: _handleTap, child: child)
        : InkWell(
            splashColor: Colors.transparent,
            enableFeedback: false,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _handleTap,
            child: child,
          );
  }
}
