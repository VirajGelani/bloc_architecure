import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart' show DeviceInfoPlugin;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  final Permission _locationPermission = Permission.location;
  final Permission _cameraPermission = Permission.camera;
  final Permission _storagePermission = Permission.storage;
  final Permission _photoPermission = Permission.photos;

  // File permissions
  final Permission _manageExternalStoragePermission =
      Permission.manageExternalStorage;

  // Private constructor to prevent instantiation from outside
  PermissionHelper._();

  static const platform = MethodChannel('samples.flutter.dev/battery');

  // Singleton instance
  static final PermissionHelper _instance = PermissionHelper._();

  // Factory method to provide access to the instance
  factory PermissionHelper() => _instance;

  final String _batteryLevel = '0';

  Future<void> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = '$result';
    } on PlatformException {
      batteryLevel = "0";
    }
    if (kDebugMode) {
      print("Battery Level:- $batteryLevel");
    }
  }

  // File read permission
  Future<bool> checkFileReadPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final status = await _manageExternalStoragePermission.status;
        return status.isGranted;
      } else {
        final status = await _storagePermission.status;
        return status.isGranted;
      }
    } else {
      // For other platforms, assume permission is granted
      return true;
    }
  }

  Future<void> requestFileReadPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final result = await _manageExternalStoragePermission.request();
        _handlePermissionResult(
          context,
          result,
          'File Read',
          'This feature requires file read permission.',
        );
      } else {
        final result = await _storagePermission.request();
        _handlePermissionResult(
          context,
          result,
          'Storage',
          'This feature requires storage permission.',
        );
      }
    } else {
      // For other platforms, assume permission is granted
    }
  }

  Future<bool> checkFileWritePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final status = await _manageExternalStoragePermission.status;
        return status.isGranted;
      } else {
        final status = await _storagePermission.status;
        return status.isGranted;
      }
    } else {
      // For other platforms, assume permission is granted
      return true;
    }
  }

  Future<void> requestFileWritePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final result = await _manageExternalStoragePermission.request();
        _handlePermissionResult(
          context,
          result,
          'File Write',
          'This feature requires file write permission.',
        );
      } else {
        final result = await _storagePermission.request();
        _handlePermissionResult(
          context,
          result,
          'Storage',
          'This feature requires storage permission.',
        );
      }
    } else {
      // For other platforms, assume permission is granted
    }
  }

  // Helper function to handle permission results
  void _handlePermissionResult(
    BuildContext context,
    PermissionStatus result,
    String permissionName,
    String message,
  ) {
    if (result.isDenied || result.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermissionDeniedDialog(
          context,
          '$permissionName Permission Required',
          message,
        );
      }
    }
  }

  Future<bool> checkLocationPermission() async {
    final status = await _locationPermission.status;
    return status.isGranted;
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    final result = await _locationPermission.request();
    if (result.isDenied || result.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermissionDeniedDialog(
          context,
          'Location Permission Required',
          'This feature requires location permission. Please enable it in your device settings.',
        );
      }
    }
  }

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (Platform.isAndroid || Platform.isIOS) {
      return status.isGranted;
    }

    return true;
  }

  Future<bool> requestCameraPermission(BuildContext context) async {
    final result = await Permission.camera.request();

    if (Platform.isAndroid) {
      if (result.isDenied || result.isPermanentlyDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(
            context,
            'Camera Permission Required',
            'This feature requires camera permission. Please enable it in your device settings.',
          );
        }
        return false;
      }
      return true;
    }

    if (Platform.isIOS) {
      if (result.isDenied || result.isRestricted) {
        if (context.mounted) {
          _showGoToSettingsDialog(
            context,
            'Camera Permission Required',
            'Camera access was denied. Please enable it in Settings > Privacy > Camera.',
          );
        }
        return false;
      }
      return true;
    }

    return true;
  }

  void _showGoToSettingsDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Opens app settings page
              Navigator.of(context).pop();
            },
            child: Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Future<bool> checkPhotoPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+ uses READ_MEDIA_IMAGES
        final status = await Permission
            .photos
            .status; // or Permission.mediaImages if using permission_handler 11+
        return status.isGranted;
      } else if (sdkInt >= 23) {
        // Android 6.0 to 12
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;

      // iOS: permission must be explicitly granted
      return status.isGranted;
    }

    // Assume permission is granted or not required on older Android (< 6.0) or other platforms
    return true;
  }

  Future<bool> requestPhotoPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // Check or request permissions for Android 13 (API 33) and above
      if (sdkInt >= 33) {
        final result = await _photoPermission.request();
        if (result.isDenied || result.isPermanentlyDenied) {
          if (context.mounted) {
            _showPermissionDeniedDialog(
              context,
              'Photos Permission Required',
              'This feature requires photo access permission. Please enable it in your device settings to use this feature. Open your device settings, find the "App Permissions" or "Privacy" section, and enable "Photos" for this app.',
            );
          }
          return false;
        }
      }
    } else if (Platform.isIOS) {}
    // For non-Android devices and Android versions below 6.0, assume permission is not required.
    return true;
  }

  Future<bool> checkStoragePermission() async {
    final status = await _storagePermission.status;
    return status.isGranted;
  }

  Future<void> requestStoragePermission(BuildContext context) async {
    final result = await _storagePermission.request();
    if (result.isDenied) {
      if (context.mounted) {
        _showPermissionDeniedDialog(
          context,
          'Storage Permission Required',
          'This feature requires storage permission. Please enable it in your device settings.',
        );
      }
    }
  }

  Future<void> _showPermissionDeniedDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
