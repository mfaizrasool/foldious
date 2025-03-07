import 'package:flutter/material.dart';
import 'package:foldious/common/ads/ads_controller.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesPreviewScreen extends StatefulWidget {
  const ImagesPreviewScreen({
    super.key,
    required this.images,
    this.selectedImage,
  });

  final List<String> images;
  final String? selectedImage;

  @override
  State<ImagesPreviewScreen> createState() => _ImagesPreviewScreenState();
}

class _ImagesPreviewScreenState extends State<ImagesPreviewScreen> {
  final FileTypeController controller = Get.put(FileTypeController());
  late PageController _pageController;
  late String currentPreviewImageNumber;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    int index = widget.selectedImage != null
        ? widget.images.indexOf(widget.selectedImage!)
        : 0;
    currentIndex = index;
    currentPreviewImageNumber = (index + 1).toString();
    _pageController = PageController(initialPage: index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  // Header with close and options buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close,
                              color: appTheme.iconTheme.color, size: 24),
                        ),

                        ///
                        Text(
                          AppLabels.images,
                          style: AppTextStyle.bodyMedium,
                        ),

                        ///
                        IconButton(
                          onPressed: () =>
                              _showImageOptionsBottomSheet(context),
                          icon: Icon(Icons.more_vert,
                              color: appTheme.iconTheme.color, size: 24),
                        ),
                      ],
                    ),
                  ),
                  if (controller.progressText.value.isNotEmpty) ...[
                    LinearProgressIndicator(
                        value: controller.downloadProgress.value),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.progressText.value,
                        style: AppTextStyle.bodyMedium,
                      ),
                    ),
                  ],
                  // PhotoViewGallery for displaying images
                  Expanded(
                    child: PhotoViewGallery.builder(
                      itemCount: widget.images.length,
                      pageController: _pageController,
                      onPageChanged: (index) => _onPageViewChange(index),
                      builder: (context, index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(widget.images[index]),
                          heroAttributes: PhotoViewHeroAttributes(
                              tag: widget.images[index]),
                          minScale: PhotoViewComputedScale.contained * 1.0,
                        );
                      },
                      backgroundDecoration: BoxDecoration(
                          color: appTheme.scaffoldBackgroundColor),
                    ),
                  ),
                  // Footer with navigation and image number
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (currentIndex > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios_sharp,
                              color: appTheme.iconTheme.color, size: 24),
                        ),
                        Text(
                          '$currentPreviewImageNumber / ${widget.images.length}',
                          style: AppTextStyle.bodyMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            if (currentIndex < widget.images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios_sharp,
                              color: appTheme.iconTheme.color, size: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value) const LoadingIndicator()
            ],
          );
        }),
      ),
    );
  }

  void _onPageViewChange(int page) {
    setState(() {
      currentIndex = page;
      currentPreviewImageNumber = (page + 1).toString();
    });
  }

  void _showImageOptionsBottomSheet(BuildContext context) {
    final appTheme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctz) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: appTheme.bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Image Options',
                style: AppTextStyle.bodyMedium
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.share,
                    color: appTheme.iconTheme.color, size: 20),
                title: Text(
                  'Share',
                  style: AppTextStyle.bodyMedium.copyWith(fontSize: 20),
                ),
                onTap: () async {
                  Get.back();

                  UnityAdsController unityAdsController = Get.find();
                  unityAdsController.showUnityAdAndNavigate(() async {
                    await controller.downloadNetworkImage(
                      fileUrl: widget.images[currentIndex],
                      isSharing: true,
                    );
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.download,
                    color: appTheme.iconTheme.color, size: 20),
                title: Text(
                  'Download',
                  style: AppTextStyle.bodyMedium.copyWith(fontSize: 20),
                ),
                onTap: () async {
                  Get.back();
                  UnityAdsController unityAdsController = Get.find();
                  unityAdsController.showUnityAdAndNavigate(() async {
                    await controller.downloadNetworkImage(
                      fileUrl: widget.images[currentIndex],
                      isSharing: false,
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
