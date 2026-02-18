import 'dart:io';

import 'package:bloc_architecure/core/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class IOHelper {
  static IOHelper? _instance;

  IOHelper._();

  static IOHelper get instance => _instance ??= IOHelper._();

  Future<Directory> getPlatformDirectory() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!;
  }

  Future<Directory?> getLocalDirPath({
    FolderType folderType = FolderType.documents,
  }) async {
    try {
      final output =
          "${(await getPlatformDirectory()).path}${Platform.pathSeparator}${folderType.value}";
      final savedDir = Directory(output);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        await savedDir.create();
      }
      return savedDir;
    } catch (err) {
      return null;
    }
  }

  Future<File?> getFileFromDirectory(
    String fileName, {
    FolderType folderType = FolderType.documents,
  }) async {
    try {
      final output = await getLocalDirPath(folderType: folderType);
      if (output == null) {
        return null;
      }
      var file = File("${output.path}${Platform.pathSeparator}$fileName");
      if (file.existsSync()) {
        return file;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<String?> getFilePathFromDirectory(
    String fileName, {
    FolderType folderType = FolderType.documents,
  }) async {
    try {
      final output = await getLocalDirPath(folderType: folderType);
      if (output == null) {
        return null;
      }
      var file = File("${output.path}${Platform.pathSeparator}$fileName");
      if (file.existsSync()) {
        debugPrint('filePath : ${file.path}');
        return file.path;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<File?> saveFileToDirectory(
    List<int> byteData,
    String fileName, {
    FolderType folderType = FolderType.documents,
  }) async {
    try {
      final output = await getLocalDirPath(folderType: folderType);
      if (output == null) {
        return null;
      }
      var file = File("${output.path}${Platform.pathSeparator}$fileName");
      await file.writeAsBytes(byteData);
      debugPrint('new File : $fileName');
      return file;
    } catch (err) {
      debugPrint('file save err = $err');
      return null;
    }
  }

  Future<File?> deleteFileToDirectory(
    String fileName, {
    FolderType folderType = FolderType.documents,
  }) async {
    try {
      final output = await getLocalDirPath(folderType: folderType);
      if (output == null) {
        return null;
      }
      var file = File("${output.path}${Platform.pathSeparator}$fileName");
      if (file.existsSync()) {
        await file.delete();
        debugPrint('delete File : $fileName');
      }
      return file;
    } catch (err) {
      debugPrint('delete save err = $err');
      return null;
    }
  }

  Future<void> clearFileStorage() async {
    try {
      final Directory appDir = await getPlatformDirectory();
      final Directory documentsDir = Directory(
        '${appDir.path}${Platform.pathSeparator}${FolderType.documents.value}',
      );
      final Directory feedbacksDir = Directory(
        '${appDir.path}${Platform.pathSeparator}${FolderType.feedbacks.value}',
      );

      if (documentsDir.existsSync()) {
        documentsDir.deleteSync(recursive: true);
      }
      if (feedbacksDir.existsSync()) {
        feedbacksDir.deleteSync(recursive: true);
      }
    } catch (err) {
      debugPrint('image folder delete err: $err');
    }
  }
}
