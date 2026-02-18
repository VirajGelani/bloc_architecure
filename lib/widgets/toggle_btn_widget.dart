// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class ToggleButtonWidget extends StatelessWidget {
//   final bool isActive;
//   final GestureTapCallback onTap;
//
//   ToggleButtonWidget(
//       {super.key,required this.isActive, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onTap,
//         child: Container(
//             height: 3.h,
//             width: 11.5.w,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4.w),
//               color:isActive ?AppColors.orange50 : AppColors.grey90,
//             ),
//             child: AnimatedAlign(
//               duration: const Duration(milliseconds: 300),
//               alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
//               child: Container(
//                 height: 3.h,
//                 width: 3.h,
//                 margin: EdgeInsets.all(0.3.w),
//                 decoration:
//                 BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
//               ),
//             )));
//   }
// }
