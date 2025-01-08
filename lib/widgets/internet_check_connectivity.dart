import 'dart:async';
import 'dart:developer' as developer;

import 'package:foldious/widgets/not_found_wifi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InternetConnectionController extends GetxController {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;

    if (_connectionStatus.contains(ConnectivityResult.none)) {
      Get.to(() => const NotFoundWifiPage());
    } else if (_connectionStatus.contains(ConnectivityResult.mobile)) {
      // Handle mobile connection
      Get.back();
    } else if (_connectionStatus.contains(ConnectivityResult.wifi)) {
      // Handle Wi-Fi connection
      Get.back();
    } else if (_connectionStatus.contains(ConnectivityResult.ethernet)) {
      // Handle Ethernet connection
      Get.back();
    } else if (_connectionStatus.contains(ConnectivityResult.vpn)) {
      // Handle VPN connection
      Get.back();
    } else if (_connectionStatus.contains(ConnectivityResult.bluetooth)) {
      // Handle Bluetooth connection
      Get.back();
    } else if (_connectionStatus.contains(ConnectivityResult.other)) {
      // Handle other types of connection1122
      // Get.back();
    }

    update();
  }

  @override
  void onClose() {
    connectivitySubscription.cancel();
    super.onClose();
  }
}
