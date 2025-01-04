import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/quran/quraa.dart';
import 'package:zekr/widgets/custom_speed.dart';

class AudioPlay extends StatelessWidget {
  AudioPlay({
    super.key,
  });
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.offAll(() => Quraa());
            },
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 30,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.5),
              Color(0xff31314f).withOpacity(1),
              Color(0xff31314f).withOpacity(1),
            ],
          )),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // CustomAppBar(),
                CustomImage(),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        customText(),
                        ControllerAudio(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Color(0xff30314d),
                                    builder: (BuildContext context) {
                                      return CustomSpeed(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                                iconSize: 40,
                                color: textColor,
                                icon: Icon(Icons.speed_outlined)),
                            Obx(
                              () => IconButton(
                                  color: textColor,
                                  iconSize: 40,
                                  onPressed: () {
                                    controller.isRepeat.value =
                                        !controller.isRepeat.value;
                                    if (controller.isRepeat.value) {
                                      controller.audioPlayer
                                          .setLoopMode(LoopMode.one);
                                    } else {
                                      controller.audioPlayer
                                          .setLoopMode(LoopMode.all);
                                    }
                                  },
                                  icon: Icon(controller.isRepeat.value
                                      ? Icons.repeat_one
                                      : Icons.repeat)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "سرعة التشغيل",
                              style: ourStyle(),
                            ),
                            Obx(
                              () => Text(
                                "${controller.playbackRate.value.toStringAsFixed(2)} X",
                                style: ourStyle(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding customText() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            StreamBuilder<SequenceState?>(
              stream: controller.audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.sequence.isEmpty) {
                  return const SizedBox();
                }
                final metadata = snapshot.data!.currentSource!.tag as MediaItem;
                return Column(
                  children: [
                    Text(metadata.title, style: ourStyle(size: 24)),
                    Text(metadata.artist ?? "", style: ourStyle(size: 24)),
                  ],
                );
              },
            ),
          ],
        ));
  }
}

//===========================
class ControllerAudio extends StatelessWidget {
  ControllerAudio({super.key});
  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => ProgressBar(
                barHeight: 4,
                baseBarColor: Colors.grey[600],
                bufferedBarColor: Colors.grey,
                progressBarColor: Colors.red,
                thumbColor: Colors.red,
                timeLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                progress: controller.position.value,
                buffered: controller.audioPlayer.bufferedPosition,
                total: controller.duration.value,
                onSeek: controller.audioPlayer.seek,
              )),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: controller.audioPlayer.seekToNext,
                  color: textColor,
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next_rounded)),
              //
              StreamBuilder<PlayerState>(
                stream: controller.audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (!(playing ?? false)) {
                    if (controller.isConnective.value ||
                        controller.isExit[controller.playIndex.value]) {
                      Get.closeAllSnackbars();
                    }
                    return IconButton(
                      onPressed: controller.audioPlayer.play,
                      color: Colors.white,
                      icon: const Icon(Icons.play_arrow_rounded),
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                        onPressed: controller.audioPlayer.pause,
                        color: Colors.white,
                        iconSize: 40,
                        icon: const Icon(Icons.pause_rounded));
                  }
                  return const Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: Colors.white,
                  );
                },
              ),
              IconButton(
                  onPressed: controller.audioPlayer.seekToPrevious,
                  color: Colors.white,
                  iconSize: 40,
                  icon: const Icon(Icons.skip_previous_rounded)),

              //
            ],
          ),
        ),
      ],
    );
  }
}

//=================================
class CustomImage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: MediaQuery.of(context).size.height * 0.35,
      width: 300,
      decoration: BoxDecoration(shape: BoxShape.circle),
      alignment: Alignment.center,
      child: RotationTransition(
        turns:
            Tween(begin: 0.0, end: 1.0).animate(controller.animationController),
        child: Image.asset(
          "images/quran.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//================================