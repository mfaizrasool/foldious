import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> getSaveDirectoryPath() async {
  String? externalStorageDirPath;

  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    const directory = "/storage/emulated/0/Download/";

    final dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      externalStorageDirPath = "/storage/emulated/0/Download/";
    } else {
      externalStorageDirPath = "/storage/emulated/0/Downloads/";
    }
  } else if (Platform.isIOS) {
    Directory dir;
    dir = await getApplicationDocumentsDirectory();
    externalStorageDirPath = dir.absolute.path;
  }

  return externalStorageDirPath;
}
