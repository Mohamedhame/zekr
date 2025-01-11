import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/controller/download/download.dart';
import 'package:zekr/controller/download/getPath_permisisson_anthor.dart';
import 'package:zekr/controller/onlin_data/supabas_data.dart';
import 'package:zekr/controller/shared/shared_data.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ========= attributes ===========================
  Connectivity connectivity = Connectivity();
  RxBool isConnective = false.obs;
  RxList allQuraa = [].obs;
  RxList filteredQuraa = [].obs;
  RxList allSurah = [].obs;
  RxList filteredSurah = [].obs;
  RxList allSerah = [].obs;
  RxList filteredSerah = [].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  RxInt playIndex = 0.obs;
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = Duration().obs;
  Rx<Duration> position = Duration().obs;
  RxDouble max = 0.0.obs;
  RxDouble value = 0.0.obs;
  late AnimationController animationController;
  RxBool isRepeat = false.obs;
  RxDouble playbackRate = 1.0.obs;
  RxDouble progress = 0.0.obs;
  RxBool isDownloding = false.obs;
  RxList isExit = [].obs;
  RxString shikhName = "".obs;
  Rx<Color> bgColor = Color(0xff303151).withOpacity(0.6).obs;
  Rx<Color> textColor = Color(0xffffffff).obs;
  Rx<Color> widgetColor = Color(0xff30314d).obs;
  RxBool isDark = true.obs;
  RxBool reminig = true.obs;
  RxDouble fontSize = 20.0.obs;
  RxInt counter = 0.obs;
  RxInt total = 0.obs;
  RxString dropdownvalue = 'سُبْحـانَ اللهِ وَبِحَمْـدِهِ'.obs;
  RxBool isProgress = false.obs;
  RxBool isMorning = true.obs;
  final PageController pageController = PageController();
  RxInt pageCurrent = 0.obs;
  RxInt count = 0.obs;
  RxInt pageCount = 0.obs;
  RxInt timeRemember = 15.obs;
  RxBool isSilent = false.obs;
  RxBool isSerah = false.obs;
  // ========= Functions ===========================

  Future<ConcatenatingAudioSource> initializePlaylist(List myList) async {
    List<AudioSource> audioSources = [];

    for (int index = 0; index < myList.length; index++) {
      String url;
      if (isExit[index]) {
        url = await GetPathPermisissonAnthor.urlFile(
          dir: shikhName.value,
          fileName: myList[index]['name'],
        );
      } else {
        url = myList[index]['url'];
      }

      audioSources.add(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: "$index",
            title: myList[index]['name'],
            artist: shikhName.value,
          ),
        ),
      );
    }

    return ConcatenatingAudioSource(children: audioSources);
  }

//===

  Future<void> initMusic(
      {required int startIndex, required List myList}) async {
    try {
      await audioPlayer.setLoopMode(LoopMode.all);
      ConcatenatingAudioSource playlist = await initializePlaylist(myList);
      await audioPlayer.setAudioSource(playlist, initialIndex: startIndex);
      await audioPlayer.seek(Duration.zero, index: startIndex);
    } catch (e) {
      log(e.toString());
    }
  }

//========================================
  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d!;
      max.value = d.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p;
      value.value = p.inSeconds.toDouble();
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        animationController.repeat();
      } else {
        animationController.stop();
      }
    });

    audioPlayer.currentIndexStream.listen((currentIndex) {
      if (currentIndex != null && currentIndex >= 0) {
        playIndex.value = currentIndex;
        log(playIndex.value.toString());
        if (!isConnective.value && !isExit[playIndex.value]) {
          audioPlayer.stop();
          Get.snackbar(
            "خطأ",
            "هذا الملف غير موجود في ذاكرة الهاتف ولا يوجد اتصال بالشبكة",
            backgroundColor: Colors.red,
            duration: Duration(days: 1),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
          );
        } else {
          Get.closeAllSnackbars();
        }
      }
    });
  }

  //===============
  void changeDurationToSecond(int seconds) {
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  //=== Play Song
  void playSong({required int startIndex, required List myList}) {
    playIndex.value = startIndex;
    try {
      initMusic(startIndex: startIndex, myList: myList);
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

// xxxxxxxxxxxx Quraa ============================
  Future<void> fetchQuraa() async {
    final data = await SupabasData().readDataFromQuraaTable();
    allQuraa.value = data;
    filteredQuraa.value = allQuraa;
  }

  void runFilterQuraa(String enteredKeyword) {
    List filtered = allQuraa
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList();
    filteredQuraa.value = filtered;
  }
// xxxxxxxxxxxxxxxxx surha ==============================

  Future<void> fetchSurah(String shikhName, String url) async {
    final data = await SupabasData()
        .readSurahFromQuraaTable(shikhName: shikhName, url: url);
    allSurah.value = data;
    filteredSurah.value = allSurah;
  }

  void runFilterSurah(String enteredKeyword) {
    List filtered = allSurah
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList();
    filteredSurah.value = filtered;
  }

  // xxxxxxxxxxxxxxxxx Serah ==============================

  Future<void> fetchSerah() async {
    final data = await SupabasData().readDataFromSerahTable();
    allSerah.value = data;
    filteredSerah.value = allSerah;
  }

  void runFilterSerah(String enteredKeyword) {
    List filtered = allSerah
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList();
    filteredSerah.value = filtered;
  }

// check connetion to internet
  void updateConnectivityStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isConnective(false);
    } else {
      isConnective(true);
    }
  }

//==== Color Theme ====
  void changeThem() {
    isDark.value = !isDark.value;
    if (isDark.value) {
      bgColor.value = Color(0xff303151).withOpacity(0.6);
      textColor.value = Color(0xffffffff);
      widgetColor.value = Color(0xff30314d);
    } else {
      bgColor.value = Color(0xffffffff);
      textColor.value = Color(0xff303151);
      widgetColor.value = Color(0xfff9f1e4);
    }
    SharedData.saveData(modeTheme, isDark.value);
  }

  //=======================
  previousPage() {
    if (pageCurrent > 0) {
      pageCurrent--;
      pageController.animateToPage(
        pageCurrent.value,
        duration: const Duration(milliseconds: 900),
        curve: Curves.ease,
      );
    }
  }

  //=====================
  nextPage() {
    if (pageCurrent < pageCount.value - 1) {
      pageCurrent++;
      pageController.animateToPage(
        pageCurrent.value,
        duration: const Duration(milliseconds: 900),
        curve: Curves.ease,
      );
    }
  }

//====================
  Future<void> togglePlay(bool isPlaying, String path) async {
    try {
      //===========
      if (!isPlaying) {
        await audioPlayer.stop();
      } else {
        await audioPlayer.setAudioSource(
          AudioSource.asset(
            "assets/$path",
            tag: MediaItem(
              id: "5",
              title: path,
            ),
          ),
        );
        await audioPlayer.play();
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  @override
  void onInit() {
    super.onInit();
    connectivity.onConnectivityChanged.listen(updateConnectivityStatus);
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 50));
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }

  //==========
  Widget icons(
    int index,
    String shikhName,
    String fileName,
    String url,
    Color textColors,
  ) {
    return IconButton(
      onPressed: () {
        if (isConnective.value) {
          if (!isExit[index]) {
            if (isDownloding.value) {
              isDownloding.value = false;
              Download().cancel();
            } else {
              isDownloding.value = true;
              Download().startDownload(
                dir: shikhName,
                fileName:
                    fileName, //"${controller.filteredSurah[index]['name']}",
                url: url, // "${controller.filteredSurah[index]['url']}",
              );
            }
            playIndex.value = index;
          }
        } else {
          Get.snackbar(
            "خطأ",
            "تحقق من الاتصال بالشبكة",
            backgroundColor: Colors.black,
            colorText: Colors.white,
            icon: const Icon(
              Icons.wifi_off,
              color: Colors.red,
            ),
          );
        }
      },
      color: textColors,
      iconSize: 20,
      icon: Obx(
        () => isDownloding.value && playIndex.value == index
            ? CircularPercentIndicator(
                radius: 15,
                lineWidth: 2,
                percent: progress.value,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.redAccent,
                backgroundColor: Colors.greenAccent,
              )
            : isExit[index]
                ? Icon(
                    Icons.download_done,
                    color: textColor.value,
                  )
                : Icon(
                    Icons.download,
                    color: textColor.value,
                  ),
      ),
    );
  }
}
