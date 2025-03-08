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
    try {
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
    } catch (e) {
      print('Error initializing Unity Ads: $e');
    }
  }

  /// Load Unity Ad
  void loadUnityAd() {
    try {
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
    } catch (e) {
      print('Error loading Unity Ad: $e');
    }
  }

  /// Show Unity Ad and trigger the navigation callback after the ad is shown
  void showUnityAdAndNavigate() {
    try {
      if (!isInitialized.value) {
        print('Unity Ads not initialized.');
        initializeUnityAds();
        return;
      }

      if (!isAdReady.value) {
        print('Ad not ready. Loading a new one...');
        loadUnityAd();
        showAd();
        return;
      } else {
        loadUnityAd();
        showAd();
      }
    } catch (e) {
      print('Error showing Unity Ad: $e');
    }
  }

  Future<void> showAd() async {
    try {
      await UnityAds.showVideoAd(
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
    } catch (e) {
      print('Error showing video ad: $e');
    }
  }
}
