import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/models/file_type_model.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/images/image_preview_screen.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/videos/video_player_screen.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/videos/web_view_screen.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/file_types.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/info_items.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:get/get.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  final FileTypeController controller = Get.put(FileTypeController());
  final ScrollController scrollController = ScrollController();
  final UserDetailsController userDetailsController = Get.find();

  String appBarTitle = "";
  late Icon fileIcon;
  late VoidCallback handleTapAction;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.allFilesPagination.clear();
      controller.getTrashFiles(
        showpaginationLoader: false,
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
    switch (file.fileType) {
      case FileTypes.image:
        Get.to(() => ImagesPreviewScreen(
              images: [controller.filePath.value],
            ));
        break;

      case FileTypes.video:
        var result = await Get.to(
          () => WebViewScreen(
            url:
                "https://foldious.com/downloader.php?file_access_key=${file.fileAccessKey}",
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
          await controller.getTrashFiles(
            showpaginationLoader: true,
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
          title: AppLabels.trash,
          showBackArrowIcon: false,
          actions: [
            if (controller.selectedFileIds.isNotEmpty) ...[
              IconButton(
                icon: const Icon(Icons.restore_from_trash_outlined),
                onPressed: () => _showConfirmationDialog('restore'),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showConfirmationDialog('delete'),
              ),
            ],
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.06),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.allFilesPagination.length,
                                  itemBuilder: (context, index) {
                                    Files file =
                                        controller.allFilesPagination[index];

                                    bool isSelected = controller.selectedFileIds
                                        .contains(file.fileAccessKey);

                                    setData(file.fileType!);

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
                                            ? Colors.green
                                                .withValues(alpha: 0.2)
                                            : Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.008),
                                          child: InfoItem(
                                            leading: fileIcon,
                                            subTitle: file.fileDate ?? "",
                                            title: file.fileName ?? "",
                                            trailingWidget:
                                                Text(file.fileSize ?? ""),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (controller.isGettingMore.value)
                                SizedBox(height: height * 0.04),
                              if (controller.isGettingMore.value)
                                SafeArea(
                                  top: false,
                                  child: SpinKitSpinningLines(
                                    color: AppColors.primaryColor,
                                    size: 50.0,
                                  ),
                                ),
                              SizedBox(height: height * 0.15),
                            ],
                          ),
                        ),
            ),
            if (controller.fileDetailsLoading.value ||
                controller.isGettingMore.value)
              LoadingIndicator()
          ],
        ),
      );
    });
  }

  void _showConfirmationDialog(String action) {
    var screenSize = MediaQuery.sizeOf(context);
    var height = screenSize.height;
    var width = screenSize.width;

    String title = action == 'restore' ? 'Restore Files' : 'Delete Files';
    String message = action == 'restore'
        ? 'Are you sure you want to restore these files?'
        : 'Are you sure you want to permanently delete these files?';

    Get.defaultDialog(
      backgroundColor: AppColors.greyColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: height * 0.02,
        horizontal: height * 0.02,
      ),
      radius: 20,
      title: title,
      titlePadding: EdgeInsets.only(top: height * 0.02),
      titleStyle: AppTextStyle.headlineSmall.copyWith(color: AppColors.white),
      content: Column(
        children: [
          Text(
            message,
            style: AppTextStyle.bodyLarge.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PrimaryButton(
                width: width * 0.3,
                title: "Cancel",
                onPressed: () => Get.back(),
              ),
              PrimaryButton(
                width: width * 0.3,
                title: "Yes",
                onPressed: () async {
                  Get.back();
                  await controller.manageFiles(
                    status: action == 'restore' ? 'publish' : 'delete',
                    fileType: "",
                  );
                  controller.exitSelectionMode();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
