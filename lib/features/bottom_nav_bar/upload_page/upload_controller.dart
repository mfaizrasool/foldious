import 'dart:math' as math;

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:get/get.dart';

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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any, // Changed to FileType.any to allow all file types
      );

      if (result != null) {
        isLoading.value = true;
        selectedFiles.clear();
        currentFileIndex.value = 0;

        // Initialize files with pending status
        selectedFiles.addAll(
          result.files.map((file) => FileUploadStatus(
                fileName: file.name,
                initialProgress: 0.0,
              )),
        );

        // Upload files sequentially
        for (int i = 0; i < result.files.length; i++) {
          currentFileIndex.value = i;
          selectedFiles[i].status.value = "Uploading...";

          // Update previous file status if exists
          if (i > 0) {
            selectedFiles[i - 1].status.value = "Completed";
          }

          await _uploadFile(i, result.files[i]);
        }

        // Update last file status
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

  Future<void> _uploadFile(int index, PlatformFile file) async {
    try {
      final filePath = file.path;
      if (filePath == null) {
        selectedFiles[index].status.value = "Error: No file path";
        return;
      }

      final int fileLength = file.size;
      const int chunkSize = 1 * 1024 * 1024; // 1MB chunks
      final int totalChunks = (fileLength / chunkSize).ceil();

      int bytesUploaded = 0;
      int currentChunkIndex = 0;

      final fileStream = dio.MultipartFile.fromFileSync(filePath).finalize();
      List<int> buffer = [];

      await for (final data in fileStream) {
        buffer.addAll(data);

        while (buffer.length >= chunkSize ||
            bytesUploaded + buffer.length == fileLength) {
          final currentChunkSize = math.min(chunkSize, buffer.length);
          final chunk = buffer.sublist(0, currentChunkSize);
          buffer = buffer.sublist(currentChunkSize);

          bytesUploaded += currentChunkSize;

          // Update progress
          final progress = bytesUploaded / fileLength;
          final sentMB = bytesUploaded / (1024 * 1024);
          final totalMB = fileLength / (1024 * 1024);

          selectedFiles[index].progress.value = progress;
          selectedFiles[index].progressLabel.value =
              "${sentMB.toStringAsFixed(2)} MB / ${totalMB.toStringAsFixed(2)} MB";

          // Upload chunk using the consistent uniqueFileName
          await _uploadChunk(
            index,
            chunk,
            currentChunkIndex,
            totalChunks,
          );

          currentChunkIndex++;

          if (bytesUploaded >= fileLength) break;
        }
      }

      selectedFiles[index].isUploaded.value = true;
      selectedFiles[index].progress.value = 1.0;
    } catch (e) {
      selectedFiles[index].status.value = "Error: ${e.toString()}";
      print("Error uploading file ${file.name}: $e");
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
      "UserChannelId" : userDetailsController.userDetails.userChannelId
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
