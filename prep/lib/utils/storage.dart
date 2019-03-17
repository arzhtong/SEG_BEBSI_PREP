import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/prepApCode.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      print("Value of the file being read - IN STORAGE: " + body);
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }

  Future<bool> fileExists() async {
    String filePath = await localPath;
    return FileSystemEntity.typeSync(filePath + "/prepApCode.txt") !=
        FileSystemEntityType.notFound;
  }
}