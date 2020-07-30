import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> getApplicationExternalStorage() async {
  String path;
  if (Platform.isAndroid) {
    path = await ExtStorage.getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    Directory directory = await getApplicationDocumentsDirectory();
    path = directory.path;
  }
  Directory directory = Directory('$path/todo_offline');
  if (await Permission.storage.request().isGranted) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  } else {
    throw Exception("Store Permission Denied");
  }
  return directory.path;
}

Future<String> getApplicationImagesStorage() async {
  String path = await getApplicationExternalStorage();
  Directory directory = Directory('$path/images');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  return directory.path;
}

Future<String> getApplicationArchiveStorage() async {
  String path = await getApplicationExternalStorage();
  Directory directory = Directory('$path/archives');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  return directory.path;
}

Future<String> getApplicationLogsStorage() async {
  String path = await getApplicationExternalStorage();
  Directory directory = Directory('$path/logs');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  return directory.path;
}
