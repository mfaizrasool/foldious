import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsController extends GetxController {
  late final WebViewController webController;
  var isLoading = true.obs;
  var isWebLoad = false.obs;

  @override
  void onInit() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            webController.runJavaScript('''
            document.querySelectorAll('.col-md-9').forEach(element => element.style.display = 'none');
            document.querySelectorAll('.col-md-3').forEach(element => element.style.display = 'none');
            document.querySelectorAll('.col-md-12').forEach(element => element.style.display = 'none');
            document.querySelectorAll('.sticky-wrapper').forEach(element => element.style.display = 'none');
             ''');
            Future.delayed(const Duration(seconds: 1), () {
              isWebLoad.value = true;
              isLoading.value = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://foldious.com/terms-and-conditions.php'),
      );

    super.onInit();
  }
}
