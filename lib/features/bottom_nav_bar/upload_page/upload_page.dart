import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foldious/features/bottom_nav_bar/upload_page/upload_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class UploadPage extends StatelessWidget {
  final UploadController controller = Get.put(UploadController());

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "File Upload Progress",
        centerTitle: true,
        showBackArrowIcon: false,
      ),
      body: Obx(() {
        return Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.isLoading.value
                              ? null
                              : Platform.isAndroid
                                  ? controller.selectFilesFunction()
                                  : _showBottomSheet(context);
                        },
                        child: Container(
                          width: width,
                          height: height * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_outlined, size: 34),
                              SizedBox(height: height * 0.01),
                              Text(
                                controller.isLoading.value
                                    ? "Uploading..."
                                    : AppLabels.selectFile,
                                style: AppTextStyle.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = controller.selectedFiles[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            file.fileName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Obx(() => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                    file.status.value),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                file.status.value,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(() => LinearProgressIndicator(
                                          value: file.progress.value,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            _getProgressColor(
                                                file.status.value),
                                          ),
                                        )),
                                    const SizedBox(height: 8),
                                    Obx(() => Text(
                                          file.progressLabel.value,
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isLoading.value && controller.selectedFiles.isEmpty)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Uploading...":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      case "Error":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Error":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilesBottomSheet(onImagesPressed: () {
        Get.back();
        Navigator.pop(context);
        controller.selectImagesAndVideos();
      }, onFilesPressed: () {
        Navigator.pop(context);
        controller.selectFiles();
      }),
    );
  }
}

class FilesBottomSheet extends StatelessWidget {
  const FilesBottomSheet({
    super.key,
    required this.onImagesPressed,
    required this.onFilesPressed,
  });

  final VoidCallback onImagesPressed;
  final VoidCallback onFilesPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: appTheme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 8.0),
          InkWell(
            onTap: onImagesPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.now_wallpaper_sharp,
                    size: 24.0,
                    color: appTheme.iconTheme.color,
                  ),
                  const SizedBox(width: 24.0),
                  Text(
                    'Photos and Videos',
                    style: AppTextStyle.titleMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onFilesPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12.0,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.more_horiz_rounded,
                    size: 24.0,
                    color: appTheme.iconTheme.color,
                  ),
                  const SizedBox(width: 24.0),
                  Text(
                    'Browse',
                    style: AppTextStyle.titleMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 110),
        ],
      ),
    );
  }
}
