import 'dart:io';

import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsController extends GetxController {
  var isInitialized = false.obs;
  var isAdReady = false.obs;

  final String gameId = Platform.isAndroid ? '5809018' : '5809019';
  final String placementId =
      Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS';

  @override
  void onInit() {
    super.onInit();
    initializeUnityAds();
  }

  /// Initialize Unity Ads
  void initializeUnityAds() {
    UnityAds.init(
      gameId: gameId,
      testMode: false,
      onComplete: () {
        isInitialized.value = true;
        print('Unity Ads Initialized Successfully');
        loadUnityAd();
      },
      onFailed: (error, message) {
        isInitialized.value = false;
        print('Unity Ads Initialization Failed: $error $message');
      },
    );
  }

  /// Load Unity Ad
  void loadUnityAd() {
    if (!isInitialized.value) {
      print('Unity Ads not initialized. Cannot load ad.');
      return;
    }

    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        isAdReady.value = true;
        print('Unity Ad Loaded Successfully: $placementId');
      },
      onFailed: (placementId, error, message) {
        isAdReady.value = false;
        print('Unity Ad Load Failed: $placementId - $error - $message');
      },
    );
  }

  /// Show Unity Ad
  void showUnityAd() {
    if (!isInitialized.value) {
      print('Unity Ads not initialized.');
      return;
    }

    if (!isAdReady.value) {
      print('Ad not ready. Loading a new one...');
      loadUnityAd();
      showUnityAd();
      return;
    }

    UnityAds.showVideoAd(
      placementId: placementId,
      onStart: (placementId) => print('Video Ad Started: $placementId'),
      onClick: (placementId) => print('Video Ad Clicked: $placementId'),
      onSkipped: (placementId) {
        isAdReady.value = false;
        print('Video Ad Skipped: $placementId');
        loadUnityAd();
      },
      onComplete: (placementId) {
        isAdReady.value = false;
        print('Video Ad Completed: $placementId');
        loadUnityAd();
      },
      onFailed: (placementId, error, message) {
        isAdReady.value = false;
        print('Video Ad Failed: $placementId - $error - $message');
        loadUnityAd();
      },
    );
  }
}
