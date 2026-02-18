import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppRefreshWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.black,
      backgroundColor: AppColors.black,
      child: child,
    );
  }
}
