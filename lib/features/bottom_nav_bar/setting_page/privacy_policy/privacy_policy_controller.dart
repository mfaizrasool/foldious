import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyController extends GetxController {
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
            // webController.runJavaScript('''
            // document.querySelectorAll('.container-fluid').forEach(element => element.style.display = 'none');
            // document.querySelectorAll('.row').forEach(element => element.style.display = 'none');
            //  ''');
            Future.delayed(const Duration(seconds: 1), () {
              isWebLoad.value = true;
              isLoading.value = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://foldious.com/privacy-policy.php'),
      );

    super.onInit();
  }
}
