// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:shikshapatri/app/utils/extension.dart';
// import 'package:sizer/sizer.dart';
//
// import '../core/constants/app_images.dart';
// import '../core/constants/app_text_size.dart';
// import 'custom_tap.dart';
//
// class CommonBottomSheetView extends StatelessWidget {
//   CommonBottomSheetView(
//       {Key? key, this.title, this.bottomWidget, this.titleAlignment,this.showCloseBtn = false})
//       : super(key: key);
//   String? title;
//   Alignment? titleAlignment;
//   Widget? bottomWidget;
//   bool showCloseBtn;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         bottom: false,
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           if (showCloseBtn)
//             Align(
//               alignment: Alignment.topRight,
//               child: CustomTap(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Container(
//                     margin: EdgeInsets.only(bottom: 1.5.h),
//                     decoration: BoxDecoration(
//                         color: AppColors.grey60.withValues(alpha: 0.8),
//                         borderRadius: BorderRadius.circular(3.w)),
//                     child: SvgPicture.asset(AppImages.onboardSvg)),
//               ),
//             ),
//           ConstrainedBox(
//             constraints: BoxConstraints(maxHeight: 75.h),
//             child: Container(
//               width: double.maxFinite,
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(3.h),
//                       topRight: Radius.circular(3.h))),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if(title!.isNotEmpty)
//                   Align(
//                       alignment: titleAlignment ?? Alignment.centerLeft,
//                       child: Text(
//                         title ?? '',
//                         textAlign: TextAlign.left,
//                         style: AppStyle.regularSitkaTextStyle(
//                             size: AppTextSize.header2,
//                             color: AppColors.grey50,
//                             letterSpacing: 0.8,
//                             fontWeight: FontWeight.w700),
//                       )),
//                   1.h.height,
//                   bottomWidget ?? const SizedBox()
//                 ],
//               ),
//             ),
//           ),
//         ]));
//   }
// }
