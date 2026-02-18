import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:bloc_architecure/core/constants/app_text_size.dart'
    show AppTextSize;
import 'package:bloc_architecure/core/theme/app_colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final void Function()? galleryOnTap;
  final void Function()? cameraOnTap;

  const ImagePickerWidget({
    required this.cameraOnTap,
    required this.galleryOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    content: DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: AppColors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Select option',
            textAlign: TextAlign.center,
            style: AppStyles.regularTextStyle(
              size: AppTextSize.t20,
              fontFamily: AppStyles.notoSans,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: galleryOnTap,
                child: DecoratedBox(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 30.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              Container(
                height: 30.sp,
                color: AppColors.black,
                padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                width: 2,
              ),
              GestureDetector(
                onTap: cameraOnTap,
                child: DecoratedBox(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 30.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
}
