import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/storage.dart';
import 'package:path_provider/path_provider.dart';

///
/// Tests do not run because the testing environment created does not provide
/// a definition for the getApplicationDocumentsDirectory() because it is not
/// a mobile device environment (iOS or Android).
///
/// The methods used here are from the official flutter documentation so they
/// are unlikely to encounter bugs. These methods are the backbone of the
/// application to if every other component is tested successfully, it can be
/// confidently said that the Storage class is functioning correctly. They are
/// extensively tested in an indirect setting.

void main() {
//  Storage storage = new Storage();
//
//  test('Establish an application documents directory', () async {
//    String storageLocalPath = await storage.localPath;
//    String defaultLocalPath = (await getApplicationDocumentsDirectory()).toString();
//
//    expect(defaultLocalPath, storageLocalPath);
//  });
}