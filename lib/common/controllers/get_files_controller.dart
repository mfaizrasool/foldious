import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/models/file_details_model.dart';
import 'package:foldious/common/models/file_type_model.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/file_types.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileTypeController extends GetxController {
  var isLoading = false.obs;
  var isGettingMore = false.obs;
  var fileDetailsLoading = false.obs;
  var currentPage = 1.obs;
  var filePath = "".obs;
  var downloadProgress = 0.0.obs;
  var progressText = "".obs;
  var isSelectionMode = false.obs;
  RxList<String> selectedFileIds = <String>[].obs;

  FileTypeModel fileTypeModel = FileTypeModel();
  FileDetailsModel fileDetailsModel = FileDetailsModel();
  RxList<Files> allFilesPagination = <Files>[].obs;

  ///
  Future<void> getPublishFiles({
    required bool showpaginationLoader,
    required String fileType,
  }) async {
    try {
      if (showpaginationLoader) {
        isGettingMore.value = true;
      } else {
        isLoading.value = true;
      }

      var userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);

      final result = await Get.find<NetworkClient>().get(
        ApiUrls.type,
        queryParameters: {
          'user_id': userId,
          'file_type': fileType,
          'page': currentPage.value,
          'file_status': FileStatus.publish,
        },
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        var data = result.rawData;
        fileTypeModel = FileTypeModel.fromJson(data);
        if (fileTypeModel.files != null) {
          currentPage.value = fileTypeModel.currentPage! + 1;
          // Add unique items to the pagination list
          allFilesPagination.addAll(fileTypeModel.files!.where(
            (newItem) => !allFilesPagination.any(
              (existingItem) => existingItem.fileId == newItem.fileId,
            ),
          ));
        }
      } else {
        showErrorMessage(result.message ?? "Failed to fetch files");
      }
    } catch (error) {
      showErrorMessage("An error occurred: $error");
    } finally {
      isLoading.value = false;
      isGettingMore.value = false;
    }
  }

  ///
  ///
  ///
  Future<void> getTrashFiles({
    required bool showpaginationLoader,
  }) async {
    try {
      if (showpaginationLoader) {
        isGettingMore.value = true;
      } else {
        isLoading.value = true;
      }

      var userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);

      final result = await Get.find<NetworkClient>().get(
        ApiUrls.type,
        queryParameters: {
          'user_id': userId,
          'page': currentPage.value,
          'file_status': FileStatus.trash,
        },
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        var data = result.rawData;
        fileTypeModel = FileTypeModel.fromJson(data);
        if (fileTypeModel.files != null) {
          currentPage.value = fileTypeModel.currentPage! + 1;
          // Add unique items to the pagination list
          allFilesPagination.addAll(fileTypeModel.files!.where(
            (newItem) => !allFilesPagination.any(
              (existingItem) => existingItem.fileId == newItem.fileId,
            ),
          ));
        }
      } else {
        showErrorMessage(result.message ?? "Failed to fetch files");
      }
    } catch (error) {
      showErrorMessage("An error occurred: $error");
    } finally {
      isLoading.value = false;
      isGettingMore.value = false;
    }
  }

  ///
  ///
  ///
  ///
  Future<void> fileDetails({required String fileAccessKey}) async {
    fileDetailsLoading.value = true;

    final result = await Get.find<NetworkClient>().get(
      ApiUrls.fileDetails,
      queryParameters: {
        'file_access_key': fileAccessKey,
      },
      sendUserAuth: true,
    );

    if (result.isSuccess) {
      var data = result.rawData;
      fileDetailsModel = FileDetailsModel.fromJson(data);
      filePath.value = fileDetailsModel.data?.fileDownloadPath ?? "";

      isLoading.value = true;
      isLoading.value = false;
      fileDetailsLoading.value = false;
    } else {
      fileDetailsLoading.value = false;
      showErrorMessage(
        result.error ?? "Error",
      );
    }
  }

  ///
  ///
  ///
  Future<void> manageFiles({
    required String status,
    required String fileType,
  }) async {
    try {
      isLoading.value = true;

      var payload = {
        "record_ids": selectedFileIds.join(','),
        "status": status,
      };

      final result = await Get.find<NetworkClient>().post(
        ApiUrls.trash,
        data: payload,
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        selectedFileIds.clear();
        allFilesPagination.clear();
        currentPage.value = 1;

        if (status == FileStatus.trash) {
          await getPublishFiles(
            showpaginationLoader: false,
            fileType: fileType,
          );
        } else {
          await getTrashFiles(
            showpaginationLoader: false,
          );
        }
      } else {
        showErrorMessage(result.error ?? "Failed to manage files");
      }
    } catch (error) {
      showErrorMessage("An error occurred: $error");
    } finally {
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  // Future<void> trashFiles() async {
  //   try {
  //     isLoading.value = true;

  //     // Prepare payload for the API call
  //     var payload = {
  //       "record_ids": selectedFileIds.join(','),
  //       "status": "trash",
  //     };

  //     final result = await Get.find<NetworkClient>().post(
  //       ApiUrls.trash,
  //       data: payload,
  //       sendUserAuth: true,
  //     );

  //     if (result.isSuccess) {
  //       selectedFileIds.clear();
  //       allFilesPagination.clear();
  //       currentPage.value = 1;
  //     } else {
  //       showErrorMessage(result.error ?? "Failed to move files to trash");
  //     }
  //   } catch (error) {
  //     showErrorMessage("An error occurred: $error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ///
  // ///
  // ///
  // Future<void> deleteFiles() async {
  //   try {
  //     isLoading.value = true;

  //     // Prepare payload for the API call
  //     var payload = {
  //       "record_ids": selectedFileIds.join(','),
  //       "status": "delete",
  //     };

  //     final result = await Get.find<NetworkClient>().post(
  //       ApiUrls.trash,
  //       data: payload,
  //       sendUserAuth: true,
  //     );

  //     if (result.isSuccess) {
  //       selectedFileIds.clear();
  //       allFilesPagination.clear();
  //       currentPage.value = 1;
  //       await getTrashFiles(
  //         showpaginationLoader: false,
  //       );
  //     } else {
  //       showErrorMessage(result.error ?? "Failed to move files to trash");
  //     }
  //   } catch (error) {
  //     showErrorMessage("An error occurred: $error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ///
  // ///
  // ///
  // Future<void> restoreFiles() async {
  //   try {
  //     isLoading.value = true;

  //     // Prepare payload for the API call
  //     var payload = {
  //       "record_ids": selectedFileIds.join(','),
  //       "status": "publish",
  //     };

  //     final result = await Get.find<NetworkClient>().post(
  //       ApiUrls.trash,
  //       data: payload,
  //       sendUserAuth: true,
  //     );

  //     if (result.isSuccess) {
  //       selectedFileIds.clear();
  //       allFilesPagination.clear();
  //       currentPage.value = 1;

  //       await getTrashFiles(
  //         showpaginationLoader: false,
  //       );
  //     } else {
  //       showErrorMessage(result.error ?? "Failed to move files to trash");
  //     }
  //   } catch (error) {
  //     showErrorMessage("An error occurred: $error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  ///
  ///
  /* -------------------------------------------------------------------------- */
  /*                                handle images                               */
  /* -------------------------------------------------------------------------- */
  ///
  Future<void> downloadNetworkImage(String fileUrl) async {
    try {
      isLoading.value = true;
      downloadProgress.value = 0.0;
      progressText.value = "0 MB / 0 MB";

      var response = await Dio().get(
        fileUrl,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          // Update download progress and text
          if (total != -1) {
            downloadProgress.value = received / total;
            progressText.value =
                "${(received / (1024 * 1024)).toStringAsFixed(1)} MB / ${(total / (1024 * 1024)).toStringAsFixed(1)} MB";
          }
        },
      );

      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: fileUrl.split("/").last,
      );
    } finally {
      isLoading.value = false;
      downloadProgress.value = 0.0;
      progressText.value = "";
    }
  }

  Future<void> shareImageButton(String imageUrl) async {
    await Share.share(imageUrl);
  }

  /* -------------------------------------------------------------------------- */
  /*                               download video                               */
  /* -------------------------------------------------------------------------- */
  Future<void> saveNetworkVideoFile(String fileUrl) async {
    isLoading.value = true;
    downloadProgress.value = 0.0;
    progressText.value = "0 MB / 0 MB";

    var appDocDir = await getTemporaryDirectory();
    String savePath = "${appDocDir.path}/temp.mp4";

    try {
      await Dio().download(
        fileUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
            progressText.value =
                "${(received / (1024 * 1024)).toStringAsFixed(1)} MB / ${(total / (1024 * 1024)).toStringAsFixed(1)} MB";
          }
        },
      );

      await ImageGallerySaverPlus.saveFile(savePath);
      isLoading.value = false;
    } finally {
      downloadProgress.value = 0.0;
      progressText.value = "";
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// Download file and open it
  Future<void> downloadAndOpenFile({required Files file}) async {
    try {
      isLoading.value = true;

      // Get temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String fileTempPath = "${tempDir.path}/${filePath.value.split("/").last}";

      // Start downloading
      await Dio().download(
        filePath.value,
        fileTempPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
            progressText.value =
                "${(received / (1024 * 1024)).toStringAsFixed(1)} MB / ${(total / (1024 * 1024)).toStringAsFixed(1)} MB";
          }
        },
      );

      // Open the downloaded file
      final result = await OpenFile.open(fileTempPath);
      debugPrint("Open File Result: ${result.message}");
      progressText.value = "";
    } catch (e) {
      progressText.value = "";
      showErrorMessage("Failed to download or open file");
      isLoading.value = false;
    } finally {
      progressText.value = "";
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  ///
  void toggleSelection({required String fileAccessKey}) {
    isLoading.value = true;
    isSelectionMode.value = true; // Enable selection mode on long press
    if (selectedFileIds.contains(fileAccessKey)) {
      selectedFileIds.remove(fileAccessKey);
    } else {
      selectedFileIds.add(fileAccessKey);
    }

    // Exit selection mode if no items are selected
    if (selectedFileIds.isEmpty) {
      isSelectionMode.value = false;
    }
    isLoading.value = false;
  }

  void exitSelectionMode() {
    isLoading.value = true;
    isSelectionMode.value = false;
    selectedFileIds.clear();
    isLoading.value = false;
  }
}
