// import 'package:bloc_architecure/core/constants/app_images.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'package:bloc_architecure/core/constants/app_text_size.dart';
// import 'package:bloc_architecure/core/theme/app_colors.dart';
// import 'package:bloc_architecure/core/theme/app_styles.dart';
// import 'package:bloc_architecure/services/local_theme_service.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool showBackArrow;
//   final Widget? prefixWidget;
//   final List<Widget>? actionsWidgets;
//   final void Function()? onTap;
//   final Color? backIconColor;
//   final bool isStartTitle;
//   final bool showSearchIcon;
//   final void Function()? onSearchTap;
//   final Color? bgColor;
//   final double? titleFontSize;
//   final bool useDashboardColors;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.showBackArrow = true,
//     this.prefixWidget,
//     this.actionsWidgets,
//     this.onTap,
//     this.backIconColor,
//     this.isStartTitle = false,
//     this.showSearchIcon = false,
//     this.onSearchTap,
//     this.bgColor,
//     this.titleFontSize,
//     this.useDashboardColors = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final actions = actionsWidgets ?? [];
//     final useLocalTheme = _hasLocalTheme();
//
//     if (useLocalTheme && bgColor == null && backIconColor == null) {
//       return _buildWithLocalTheme(actions);
//     }
//
//     return _buildWithGlobalTheme(actions);
//   }
//
//   Widget _buildWithLocalTheme(List<Widget> actions) {
//     final localThemeService = Get.find<LocalThemeService>();
//     final isUsingLocal = localThemeService.useLocalTheme.value;
//     final effectiveIsDark = isUsingLocal ? localThemeService.isDark : isDark;
//
//     final effectiveBgColor = _getBackgroundColor(effectiveIsDark, isUsingLocal);
//     final effectiveTitleColor = _getTitleColor(effectiveIsDark, isUsingLocal);
//     final effectiveIconColor = _getIconColor(
//       effectiveIsDark,
//       isUsingLocal,
//       useDashboardColors,
//     );
//     final leading = _buildLeadingWidget(effectiveIconColor);
//
//     return _buildAppBar(
//       effectiveBgColor,
//       effectiveTitleColor,
//       leading,
//       actions,
//       showSearchIcon,
//       isStartTitle,
//       titleFontSize,
//       title,
//     );
//   }
//
//   Widget _buildWithGlobalTheme(List<Widget> actions) {
//     final effectiveIsDark = isDark;
//     final effectiveBgColor = _getBackgroundColor(effectiveIsDark, false);
//     final effectiveTitleColor = _getTitleColor(effectiveIsDark, false);
//     final effectiveIconColor = _getIconColor(
//       effectiveIsDark,
//       false,
//       useDashboardColors,
//     );
//     final leading = _buildLeadingWidget(effectiveIconColor);
//
//     return _buildAppBar(
//       effectiveBgColor,
//       effectiveTitleColor,
//       leading,
//       actions,
//       showSearchIcon,
//       isStartTitle,
//       titleFontSize,
//       title,
//     );
//   }
//
//   Color _getBackgroundColor(bool isDark, bool isUsingLocal) {
//     if (bgColor != null) return bgColor!;
//
//     if (useDashboardColors) {
//       if (isUsingLocal) {
//         return isDark ? Colors.transparent : AppColors.themeCream300Light;
//       }
//       return isDark ? Colors.transparent : AppColors.themeBgPage;
//     }
//
//     if (isUsingLocal) {
//       return isDark ? Colors.transparent : AppColors.appPageBgLight;
//     }
//     return isDark ? Colors.transparent : AppColors.appPageBg;
//   }
//
//   Color _getTitleColor(bool isDark, bool isUsingLocal) {
//     if (isUsingLocal) {
//       return isDark ? AppColors.themeCream300Dark : AppColors.themeRedDarkLight;
//     }
//     return isDark ? AppColors.themeCream300Dark : AppColors.themeRedDarkLight;
//   }
//
//   Color _getIconColor(bool isDark, bool isUsingLocal, bool useDashboard) {
//     if (isUsingLocal) {
//       if (useDashboard) {
//         return isDark
//             ? AppColors.themeCream300Dark
//             : AppColors.themeCream900Light;
//       }
//       return AppColors.appPrimaryText;
//     }
//
//     return useDashboard ? AppColors.themeIcon : AppColors.appPrimaryText;
//   }
//
//   Widget? _buildLeadingWidget(Color iconColor) {
//     final leadingWidgets = <Widget>[];
//
//     if (prefixWidget != null) {
//       leadingWidgets.add(prefixWidget!);
//     }
//
//     if (prefixWidget == null && showBackArrow) {
//       leadingWidgets.add(
//         CustomTap(
//           onTap: onTap ?? Get.back,
//           child: Container(
//             height: kToolbarHeight * 0.8,
//             color: Colors.transparent,
//             padding: EdgeInsets.symmetric(horizontal: 2.screenWidth),
//             child: SvgPicture.asset(
//               AppImages.backArrowSvg,
//               width: 3.screenWidth,
//               fit: BoxFit.fitWidth,
//               colorFilter: ColorFilter.mode(
//                 backIconColor ?? iconColor,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (showSearchIcon) {
//       leadingWidgets.add(
//         GestureDetector(
//           onTap: onSearchTap,
//           child: Container(
//             margin: const EdgeInsets.only(left: 10),
//             child: RoundedRectIcon(
//               svg: AppImages.searchGlossary,
//               size: 20,
//               radius: 14,
//               padding: 8,
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (leadingWidgets.isEmpty) return null;
//
//     return Padding(
//       padding: EdgeInsets.only(left: AppConstants.horizontalSpace),
//       child: Row(mainAxisSize: MainAxisSize.min, children: leadingWidgets),
//     );
//   }
//
//   Widget _buildAppBar(
//     Color effectiveBgColor,
//     Color effectiveTitleColor,
//     Widget? leading,
//     List<Widget> actions,
//     bool showSearchIcon,
//     bool isStartTitle,
//     double? titleFontSize,
//     String title,
//   ) {
//     return AppBar(
//       backgroundColor: effectiveBgColor,
//       surfaceTintColor: effectiveBgColor,
//       leading: leading,
//       leadingWidth: showSearchIcon ? 30.screenWidth : 18.screenWidth,
//       title: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 2.screenWidth),
//         child: Text(
//           title,
//           style: AppStyles.regularTextStyle(
//             size: titleFontSize ?? AppTextSize.t19,
//             fontWeight: FontWeight.bold,
//             color: effectiveTitleColor,
//             fontFamily: AppStyles.aleo,
//           ),
//           textAlign: isStartTitle ? TextAlign.start : TextAlign.center,
//         ),
//       ),
//       actions: [
//         if (actions.isNotEmpty)
//           Padding(
//             padding: EdgeInsets.only(right: AppConstants.horizontalSpace),
//             child: Row(children: actions),
//           )
//         else
//           SizedBox(width: AppConstants.horizontalSpace),
//       ],
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       shadowColor: Colors.transparent,
//       centerTitle: !isStartTitle,
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//
//   /// Checks if LocalThemeService is available (screen has local theme)
//   bool _hasLocalTheme() {
//     try {
//       return Get.isRegistered<LocalThemeService>();
//     } catch (e) {
//       return false;
//     }
//   }
// }
