import 'dart:convert';
import 'dart:developer';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/onlin_data/json_file.dart';

class SupabasData {
  final supabase = Supabase.instance.client;
  final controller = Get.find<HomeController>();
  //======================== Functions ===================================
  // Sign In to supabase
  void signIn() async {
    try {
      await supabase.auth
          .signInWithPassword(password: "123456", email: "mohamed@email.com");
      log("Successfully");
    } catch (e) {
      print(e);
    }
  }

  // Get Quraa from Supabase

  Future<List<Map>> readDataFromQuraaTable() async {
    List<Map<String, dynamic>> names = [];
    final readFromJson = await JsonFile.read('my_file.json');
    if (readFromJson.isNotEmpty) {
      log("From Json");
      return readFromJson;
    } else {
      log("From Supabase");

      if (controller.isConnective.value) {
        final data = supabase.from('quraa').select();

        for (var element in await data) {
          names.add({"name": element['name'], "url": element['url']});
        }
        String updatedJsonString = jsonEncode(names);
        await JsonFile.writeTemp('my_file.json', updatedJsonString);
      }
      return names;
    }
  }

  //======================================
  //Get Suhar for shisk
  Future<List<Map>> readSurahFromQuraaTable(
      {required String shikhName, required String url}) async {
    List<Map<String, dynamic>> names = [];
    final readFromJson = await JsonFile.read('$shikhName.json');
    if (readFromJson.isNotEmpty) {
      log("From Json");
      return readFromJson;
    } else {
      log("From Supabase");
      if (controller.isConnective.value) {
        final data = await supabase.from('quraa').select('data').eq('url', url);
        for (var element in data) {
          for (var element in element['data']) {
            names.add({
              "name": "${element['name']}",
              "url": "${element['url']}",
            });
          }
        }
        String updatedJsonString = jsonEncode(names);
        await JsonFile.writeTemp('$shikhName.json', updatedJsonString);
      }
      return names;
    }
  }

//================hadith==================
  Future<List> readData() async {
    signIn();
    final data = supabase.from('hadith').select();

    return data;
  }

//================================================
  Future<void> insertHadithToDatabase() async {
    try {
      List<Map<String, dynamic>> hadithInDatabase = [];
      for (var element in await HadithDatabase.getHadith()) {
        hadithInDatabase.add({
          "id": element['id'],
          "title": element['title'],
          "nuse": element['nuse'],
          "explain": element['explain'],
          "rawy": element['rawy'],
          "note": element['note']
        });
      }

      List<Map<String, dynamic>> hadithInSupabase = [];
      for (var element in await readData()) {
        hadithInSupabase.add({
          "id": element['id'],
          "title": element['title'],
          "nuse": element['nuse'],
          "explain": element['explain'],
          "rawy": element['rawy'],
          "note": element['note']
        });
      }

      for (var element in hadithInSupabase) {
        if (hadithInDatabase.any((e) =>
            e['title'] == element['title'] && e['nuse'] == element['nuse'])) {
        } else {
          await HadithDatabase.addHadith(element);
        }
      }
    } catch (e) {
      print("Error in insertIntoDatabase: $e");
    }
  }
}
