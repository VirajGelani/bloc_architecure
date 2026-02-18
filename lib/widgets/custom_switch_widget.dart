import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? AppColors.black : AppColors.black,
          border: Border.all(color: AppColors.black, width: 1.4),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 22 : 2,
              top: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.black : AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
