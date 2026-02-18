import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:bloc_architecure/widgets/button_widget.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  Future<void> _launchStore() async {
    try {
      final Uri storeUrl;
      if (Platform.isAndroid) {
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;
        storeUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName',
        );
      } else {
        // iOS App Store URL - uses App Store ID (not bundle identifier)
        storeUrl = Uri.parse('https://apps.apple.com/app/id');
        // Alternative: Use itms-apps scheme for direct App Store app launch
        // storeUrl = Uri.parse('itms-apps://itunes.apple.com/app/id${AppConstants.iosAppStoreId}');
      }

      // if (await canLaunchUrl(storeUrl)) {
      //   await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
      // } else {
      //   debugPrint('Cannot launch store URL: $storeUrl');
      // }
    } catch (e) {
      debugPrint('Error launching store: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent dismissing the dialog
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMain),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMain),
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.screenWidth,
              horizontal: 2.screenWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Section
                Padding(
                  padding: EdgeInsets.only(
                    top: 1.screenWidth,
                    bottom: 1.screenHeight,
                  ),
                  child: Text(
                    'update required',
                    style: AppStyles.regularTextStyle(
                      size: AppTextSize.t19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Message Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.screenWidth,
                    vertical: 1.screenHeight,
                  ),
                  child: Text(
                    'updateRequiredMessage',
                    style: AppStyles.regularTextStyle(
                      size: AppTextSize.t15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Spacing before button
                4.height,
                // Update Button
                ButtonWidget(
                  text: 'Update now',
                  isPrimary: true,
                  onPressed: _launchStore,
                  height: 5.screenHeight,
                ),
                // Bottom spacing
                1.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
