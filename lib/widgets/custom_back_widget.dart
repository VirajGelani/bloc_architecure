import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:bloc_architecure/core/constants/app_images.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/widgets/bounceable.dart';

class CustomBackWidget extends StatelessWidget {
  final Function()? onTap;

  const CustomBackWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: kToolbarHeight,
        width: kToolbarHeight,
        color: Colors.transparent,
        padding: EdgeInsets.all(kToolbarHeight * .35),
        child: SvgPicture.asset(
          AppImages.icon,
          fit: BoxFit.fitHeight,
          colorFilter: AppColors.black.color,
        ),
      ),
    );
  }
}
