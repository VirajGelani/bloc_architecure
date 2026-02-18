// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sizer/sizer.dart';
//
// import '../core/constants/app_images.dart';
//
// class CheckBoxWidget extends StatelessWidget {
//   final bool isSelected;
//   final GestureTapCallback onTap;
//
//   CheckBoxWidget({super.key,required this.isSelected, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onTap,
//         child:  Container(
//           width: 4.w,
//           height: 2.h,
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//               color: isSelected
//                   ? AppColors.orange50
//                   : AppColors.white,
//               border: Border.all(
//                   color: AppColors.appPrimary,
//                   width: 1.1),
//               borderRadius: BorderRadius.circular(0.4.w)),
//           child: isSelected
//               ? SvgPicture.asset(
//             AppImages.onboardSvg,
//             colorFilter: ColorFilter.mode(
//                 AppColors.white, BlendMode.srcIn),
//           )
//               : const SizedBox(),
//         ),
//     );
//   }
// }
