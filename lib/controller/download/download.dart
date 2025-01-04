import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:zekr/controller/download/getPath_permisisson_anthor.dart';
import 'package:zekr/controller/home_controller.dart';

class Download {
  final HomeController controller = Get.find<HomeController>();
  CancelToken cancelToken = CancelToken();
  void startDownload(
      {required String dir,
      required String fileName,
      required String url}) async {
    String pathDirectory = await GetPathPermisissonAnthor.getPath(dir);
    String pathFile = "$pathDirectory/$fileName.mp3";
    final File file = File(pathFile);
    int downloadedLength = 0;
    try {
      if (await file.exists()) {
        log("$file");
        downloadedLength = await file.length();
      }

      final raf = await file.open(mode: FileMode.append);
      //====
      final response = await Dio().get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "Content-Type": "application/octet-stream",
            "range": "bytes=$downloadedLength-",
          },
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
        cancelToken: cancelToken,
      );
      //====
      int received = 0;
      final total = response.data?.contentLength ?? 0;
      await for (var chunk in response.data!.stream) {
        await raf.writeFrom(chunk);
        received += chunk.length;

        if (total != -1) {
          controller.progress.value =
              ((downloadedLength + received) / total).clamp(0.0, 1.0);
        }
      }
      await raf.close();

      log("اكتمل التحميل.");
      controller.isDownloding.value = false;
    } on DioException catch (e) {
      controller.isDownloding.value = false;
      if (e.type == DioExceptionType.cancel) {
        print("تم إلغاء التحميل. الملف المحمل جزئيًا محفوظ.");
      } else {
        print("حدث خطأ أثناء التحميل: $e");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      controller.isDownloding.value = false;
    }
  }

  void cancel() {
    cancelToken.cancel();
  }
}
