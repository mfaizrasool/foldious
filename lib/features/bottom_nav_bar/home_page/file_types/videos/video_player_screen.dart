import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.fileUrl});
  final String fileUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final FileTypeController controller = Get.put(FileTypeController());
  late VideoPlayerController _videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.fileUrl));
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      looping: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.positiveColor,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    _videoPlayerController.initialize().then((_) {
      setState(() {});
      chewieController!.play();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> _handleBackNavigation() async {
    if (_videoPlayerController.value.isPlaying) {
      await _videoPlayerController.pause();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await _handleBackNavigation();
        return;
      },
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: AppLabels.videos,
          onBackPressed: _handleBackNavigation,
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => controller.saveNetworkVideoFile(widget.fileUrl),
            )
          ],
        ),
        backgroundColor: appTheme.scaffoldBackgroundColor,
        body: Obx(() {
          return Stack(
            children: [
              Center(
                child: chewieController != null &&
                        chewieController!
                            .videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: chewieController!
                            .videoPlayerController.value.aspectRatio,
                        child: Chewie(
                          controller: chewieController!,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Loading...",
                            style: AppTextStyle.bodyMedium,
                          ),
                          SpinKitSpinningLines(
                            color: AppColors.primaryColor,
                            size: 50.0,
                          ),
                        ],
                      ),
              ),
              if (controller.progressText.value.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
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
                  ),
                ),
              if (controller.isLoading.value) const LoadingIndicator()
            ],
          );
        }),
      ),
    );
  }
}
