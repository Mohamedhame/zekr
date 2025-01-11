import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonFile {
  //==== Write in json file =========
  static Future<void> writeTemp(String path, String text) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$path');
      await file.writeAsString(text);
      print("done");
    } catch (e) {
      print(e.toString());
    }
  }

  //==== Read from json file ======
  static Future<List<Map>> read(String path) async {
    List<Map<String, dynamic>> names = [];
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$path');
      String text = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(text);

      for (var element in jsonData) {
        names.add({"name": element['name'], "url": element['url']});
      }
    } catch (e) {
      print("Couldn't read file");
    }
    return names;
  }

  //=====

  static Future<List<Map>> readSerah(String path) async {
    List<Map<String, dynamic>> names = [];
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$path');
      String text = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(text);

      for (var element in jsonData) {
        names.add({
          "id": element['id'],
          "name": element['name'],
          "url": element['url']
        });
      }
    } catch (e) {
      print("Couldn't read file");
    }
    return names;
  }
}
