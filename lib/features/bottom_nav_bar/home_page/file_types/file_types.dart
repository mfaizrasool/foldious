import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/models/file_type_model.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/images/image_preview_screen.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/videos/video_player_screen.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/videos/web_view_screen.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/file_types.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/info_items.dart';
import 'package:foldious/widgets/loading_image.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class FileTypesScreen extends StatefulWidget {
  const FileTypesScreen({super.key, required this.fileType});
  final String fileType;

  @override
  State<FileTypesScreen> createState() => _FileTypesScreenState();
}

class _FileTypesScreenState extends State<FileTypesScreen> {
  final FileTypeController controller = Get.put(FileTypeController());
  final ScrollController scrollController = ScrollController();
  final UserDetailsController userDetailsController = Get.find();

  String appBarTitle = "";
  late Icon fileIcon;
  late VoidCallback handleTapAction;

  @override
  void initState() {
    super.initState();

    setData(widget.fileType);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.allFilesPagination.clear();
      controller.isSelectionMode.value = false;
      controller.currentPage.value = 1;
      controller.getPublishFiles(
        showpaginationLoader: false,
        fileType: widget.fileType,
      );
    });
    onMaxScroll();
  }

  /// Set data dynamically based on the file type
  void setData(String fileType) {
    switch (fileType) {
      case FileTypes.image:
        appBarTitle = AppLabels.images;
        fileIcon = const Icon(Icons.image, color: Colors.green);
        break;
      case FileTypes.video:
        appBarTitle = AppLabels.videos;
        fileIcon = const Icon(Icons.movie, color: Colors.red);
        break;
      case FileTypes.text:
        appBarTitle = AppLabels.documents;
        fileIcon = const Icon(Icons.description, color: Colors.blue);
        break;
      case FileTypes.application:
        appBarTitle = AppLabels.others;
        fileIcon = const Icon(Icons.other_houses, color: Colors.orange);
        break;
      default:
        appBarTitle = AppLabels.others;
        fileIcon = const Icon(Icons.file_present, color: Colors.grey);
    }
  }

  /// Handle taps dynamically based on file type
  void handleTap(Files file) async {
    await controller.fileDetails(fileAccessKey: file.fileAccessKey ?? "");

    switch (widget.fileType) {
      case FileTypes.image:
        Get.to(() => ImagesPreviewScreen(
              images: [controller.filePath.value],
            ));
        break;

      case FileTypes.video:
        var result = await Get.to(
          () => WebViewScreen(
            url: "${ApiUrls.webViewVideoPath}${file.fileAccessKey}&download=1",
          ),
        );
        if (result != null) {
          var url = Uri.parse(result);
          Get.to(() => VideoPlayerScreen(fileUrl: url.toString()));
        }
        break;

      case FileTypes.text:
        await controller.downloadAndOpenFile(file: file);
        break;

      case FileTypes.application:
        // Handle applications logic if any
        break;

      default:
        showErrorMessage("Unsupported file type.");
    }
  }

  void onMaxScroll() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (controller.fileTypeModel.haveMoreData ?? false) {
          await controller.getPublishFiles(
            showpaginationLoader: true,
            fileType: widget.fileType,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    var height = screenSize.height;
    var width = screenSize.width;

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          centerTitle: true,
          title: appBarTitle,
          onBackPressed: () async {
            Get.back();
            await userDetailsController.getUserDetails();
          },
          actions: [
            if (controller.selectedFileIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  print("Selected IDs: ${controller.selectedFileIds}");
                  await controller.manageFiles(
                    status: FileStatus.trash,
                    fileType: widget.fileType,
                  );
                },
              ),
            if (controller.isSelectionMode.value)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => controller.exitSelectionMode(),
              ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: controller.isLoading.value
                  ? const LoadingIndicator()
                  : controller.allFilesPagination.isEmpty
                      ? Center(
                          child: Text(
                            AppLabels.noFilesFound,
                            style: AppTextStyle.headlineSmall,
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.02),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: controller.allFilesPagination.length,
                                itemBuilder: (context, index) {
                                  Files file =
                                      controller.allFilesPagination[index];
                                  bool isSelected = controller.selectedFileIds
                                      .contains(file.fileAccessKey);
                                  return GestureDetector(
                                    onLongPress: () =>
                                        controller.toggleSelection(
                                      fileAccessKey: file.fileAccessKey!,
                                    ),
                                    onTap: controller.isSelectionMode.value
                                        ? () => controller.toggleSelection(
                                              fileAccessKey:
                                                  file.fileAccessKey!,
                                            )
                                        : () => handleTap(file),
                                    child: Container(
                                      color: isSelected
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : Colors.transparent,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: height * 0.01,
                                          horizontal: width * 0.06,
                                        ),
                                        child: InfoItem(
                                          isLeadingPading: false,
                                          leading: FileTypes.image ==
                                                      file.fileType &&
                                                  (file.fileDownloadPath !=
                                                          null &&
                                                      file.fileDownloadPath!
                                                          .isNotEmpty)
                                              ? SizedBox(
                                                  height: height * 0.07,
                                                  width: height * 0.07,
                                                  child: LoadingImage(
                                                    imageUrl:
                                                        file.fileDownloadPath!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : fileIcon,

                                          ///
                                          subTitle: file.fileDate ?? "",
                                          title: file.fileName!.split("_").last,
                                          trailingWidget:
                                              Text(file.fileSize ?? ""),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: height * 0.1),
                              if (controller.isGettingMore.value)
                                SpinKitSpinningLines(
                                  color: AppColors.primaryColor,
                                  size: 50.0,
                                ),
                              SizedBox(height: height * 0.15),
                            ],
                          ),
                        ),
            ),
            if (controller.fileDetailsLoading.value) LoadingIndicator()
          ],
        ),
      );
    });
  }
}
