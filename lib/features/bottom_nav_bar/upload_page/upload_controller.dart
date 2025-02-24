import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUploadStatus {
  final String fileName;
  final String uniqueFileName;
  final RxDouble progress;
  final RxBool isUploaded;
  final RxString progressLabel;
  final RxString status;

  FileUploadStatus({
    required this.fileName,
    required double initialProgress,
  })  : uniqueFileName =
            "${math.Random().nextInt(90000000) + 10000000}_$fileName",
        progress = initialProgress.obs,
        isUploaded = false.obs,
        progressLabel = "0.00 MB / 0.00 MB".obs,
        status = "Pending".obs;
}

class UploadController extends GetxController {
  var isLoading = false.obs;
  var selectedFiles = <FileUploadStatus>[].obs;
  var currentFileIndex = 0.obs;
  final UserDetailsController userDetailsController = Get.find();

  void selectFiles() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isDenied) {
      openAppSettings();
    } else {
      try {
        print("Storage Access Granted");
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );

        if (result != null) {
          isLoading.value = true;
          selectedFiles.clear();
          currentFileIndex.value = 0;

          selectedFiles.addAll(
            result.files.map((file) => FileUploadStatus(
                  fileName: file.name,
                  initialProgress: 0.0,
                )),
          );

          for (int i = 0; i < result.files.length; i++) {
            currentFileIndex.value = i;
            selectedFiles[i].status.value = "Uploading...";

            if (i > 0) {
              selectedFiles[i - 1].status.value = "Completed";
            }

            await _uploadFile(i, File(result.files[i].path!));
          }

          if (selectedFiles.isNotEmpty) {
            selectedFiles.last.status.value = "Completed";
          }

          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        print("Error selecting files: $e");
      }
    }
  }

  void selectImagesAndVideos() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isDenied) {
      openAppSettings();
    } else {
      try {
        print("Photo Library Access Granted");
        final ImagePicker picker = ImagePicker();
        List<XFile>? pickedFiles = await picker.pickMultipleMedia();

        if (pickedFiles.isNotEmpty) {
          isLoading.value = true;
          selectedFiles.clear();
          currentFileIndex.value = 0;

          selectedFiles.addAll(
            pickedFiles.map((file) => FileUploadStatus(
                  fileName: file.name,
                  initialProgress: 0.0,
                )),
          );

          for (int i = 0; i < pickedFiles.length; i++) {
            currentFileIndex.value = i;
            selectedFiles[i].status.value = "Uploading...";

            if (i > 0) {
              selectedFiles[i - 1].status.value = "Completed";
            }

            await _uploadFile(i, File(pickedFiles[i].path));
          }

          if (selectedFiles.isNotEmpty) {
            selectedFiles.last.status.value = "Completed";
          }

          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        print("Error selecting files: $e");
      }
    }
  }

  Future<void> _uploadFile(int index, File file) async {
    try {
      final fileLength = file.lengthSync();
      const int chunkSize = 1 * 1024 * 1024;
      final int totalChunks = (fileLength / chunkSize).ceil();
      int bytesUploaded = 0;
      int currentChunkIndex = 0;

      final fileStream = file.openRead();
      List<int> buffer = [];

      await for (final data in fileStream) {
        buffer.addAll(data);
        while (buffer.length >= chunkSize ||
            bytesUploaded + buffer.length == fileLength) {
          final currentChunkSize = math.min(chunkSize, buffer.length);
          final chunk = buffer.sublist(0, currentChunkSize);
          buffer = buffer.sublist(currentChunkSize);

          bytesUploaded += currentChunkSize;
          final sentMB = bytesUploaded / (1024 * 1024);
          final totalMB = fileLength / (1024 * 1024);

          selectedFiles[index].progress.value = bytesUploaded / fileLength;
          selectedFiles[index].progressLabel.value =
              "${sentMB.toStringAsFixed(2)} MB / ${totalMB.toStringAsFixed(2)} MB";

          await _uploadChunk(index, chunk, currentChunkIndex, totalChunks);

          currentChunkIndex++;
          if (bytesUploaded >= fileLength) break;
        }
      }

      selectedFiles[index].isUploaded.value = true;
      selectedFiles[index].status.value = "Completed";
    } catch (e) {
      selectedFiles[index].status.value = "Error: ${e.toString()}";
      print("Error uploading file ${file.path}: $e");
    }
  }

  Future<void> _uploadChunk(
    int fileIndex,
    List<int> chunk,
    int chunkIndex,
    int totalChunks,
  ) async {
    final String uniqueFileName = selectedFiles[fileIndex].uniqueFileName;

    final formData = dio.FormData.fromMap({
      "chunkIndex": chunkIndex,
      "totalChunks": totalChunks,
      "fileName": uniqueFileName,
      "fileChunk": dio.MultipartFile.fromBytes(
        chunk,
        filename: "${uniqueFileName}_chunk_$chunkIndex",
      ),
      "UserId": userDetailsController.userDetails.userId,
      "FolderId": userDetailsController.folderDetails.folderKey,
      "UserChannelId": userDetailsController.userDetails.userChannelId
    });

    print(
        "Uploading chunk $chunkIndex of $totalChunks for file: $uniqueFileName");
    print("formData ${formData.fields}");

    await Get.find<NetworkClient>().post(
      ApiUrls.counterUpload,
      data: formData,
    );
  }
}
