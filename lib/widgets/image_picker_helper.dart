import 'package:bloc_architecure/utils/permission_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      bool hasPermission = false;

      if (source == ImageSource.camera) {
        hasPermission = await PermissionHelper().checkCameraPermission();

        if (!hasPermission) {
          // hasPermission = await PermissionHelper().requestCameraPermission(
          //   Get.context!,
          // );
        }
      } else {
        hasPermission = await PermissionHelper().checkPhotoPermission();

        if (!hasPermission) {
          // hasPermission = await PermissionHelper().requestPhotoPermission(
          //   Get.context!,
          // );
        }
      }

      if (!hasPermission) return null;

      final picker = ImagePicker();
      return await picker.pickImage(source: source);
    } on PlatformException {
      // await _showSettingsDialog(Get.context!);
      return null;
    } catch (e) {
      // final context = Get.context;
      // if (context != null && context.mounted) {
      //   final label = AppLocalizations.of(context);
      //   if (label != null) {
      //     SnackBarWidget.showSnackBar(label.failedToPickImage, isError: true);
      //   }
      // }
      return null;
    }
  }

  static Future<void> _showSettingsDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Please enable permission in Settings to proceed."),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
