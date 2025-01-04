import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPathPermisissonAnthor {
  static Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
        if (build.version.sdkInt >= 30) {
          await Permission.manageExternalStorage.request();
          if (await Permission.manageExternalStorage.isGranted) {
            return true;
          } else {
            return false;
          }
        } else {
          return await _permissionReq(Permission.storage);
        }
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //==========================
  static Future<bool> _permissionReq(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result.isGranted;
    }
  }

  //============================
  static Future<String> getPath(String dir) async {
    await requestStoragePermission();
    try {
      Directory? docDir = await getExternalStorageDirectory();
      List<String> address = docDir!.path.split('/');
      List<String> newAddressList = [];
      for (var i = 0; i < address.length; i++) {
        if (i < 4) {
          newAddressList.add(address[i]);
        }
      }
      String newAddress = newAddressList.join("/");

      String relativePath = "$newAddress/zekr/$dir";
      Directory directory = Directory(relativePath);
      if (await directory.exists()) {
        return directory.path;
      } else {
        await directory.create(recursive: true);
        return directory.path;
      }
    } catch (e) {
      log("حدث خطأ: $e");
      return e.toString();
    }
  }

  static Future<bool> checkExist(
      {required String dir, required String fileName}) async {
    String pathDirectory = await getPath(dir);
    String pathFile = "$pathDirectory/$fileName.mp3";
    final File file = File(pathFile);
    if (await file.exists()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> urlFile(
      {required String dir, required String fileName}) async {
    String pathDirectory = await getPath(dir);
    String pathFile = "$pathDirectory/$fileName.mp3";
    return pathFile;
  }

  static void openSpecificPath({required String dir}) async {
    String folderPath = await getPath(dir);
    final result = await OpenFile.open(folderPath);
    if (result.type == ResultType.done) {
      print("Opened successfully");
    } else {
      print("Error: ${result.message}");
    }
  }

//=========
}
