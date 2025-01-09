import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url});
  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final FileTypeController controller = Get.put(FileTypeController());
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings =
      InAppWebViewSettings(isInspectable: kDebugMode);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.blue,
  );
  bool pullToRefreshEnabled = true;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  bool _isVideoUrl(String path) {
    // List of supported video extensions
    const videoExtensions = [
      ".mp4",
      ".mov",
      ".avi",
      ".wmv",
      ".flv",
      ".mkv",
      ".webm",
    ];

    // Check if the path ends with any of the extensions
    return videoExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: "Preview",
          centerTitle: true,
        ),
        body: controller.isLoading.value
            ? const LoadingIndicator()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                      initialSettings: settings,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (InAppWebViewController controller) {
                        webViewController = controller;
                      },
                      onLoadStop: (controller, url) {
                        pullToRefreshController?.endRefreshing();
                      },
                      onReceivedError: (controller, request, error) {
                        pullToRefreshController?.endRefreshing();
                      },
                      onLoadStart: (controller, url) {
                        if (url != null && _isVideoUrl(url.path)) {
                          controller.stopLoading();
                          if (mounted) {
                            Navigator.of(context).pop(url.toString());
                          }
                        }
                      },
                      onDownloadStartRequest: (ctrl, request) async {
                        String fileUrl = request.url.toString();
                        print("fileUrl === $fileUrl");

                        await controller
                            .saveNetworkVideoFile(request.url.toString());
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                      },
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
