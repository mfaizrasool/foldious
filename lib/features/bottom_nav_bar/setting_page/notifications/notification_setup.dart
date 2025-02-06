/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
///
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:foldious/features/splash_screen/splash_screen.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:get/get.dart';

class NotificationSetup {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            announcement: true,
            sound: true,
            provisional: true,
            badge: true,
            carPlay: true);

/* -------------------------------------------------------------------------- */
/*                             ANDROID PERMISSION                             */
/* -------------------------------------------------------------------------- */
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('Android Settings Permission');
      }
/* -------------------------------------------------------------------------- */
/*                               iOS PERMISSION                               */
/* -------------------------------------------------------------------------- */
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('iOS Settings Permission');
      }
    } else {
      AppSettings.openAppSettings();
      if (kDebugMode) {
        print('Settings Permission Denied');
      }
    }
  }

/* -------------------------------------------------------------------------- */
/*                     FIREBASE NOTIFICATION INTIALIZATION                    */
/* -------------------------------------------------------------------------- */

  void firebaseNontificationInit(BuildContext context) {
    // if (firebaseAuth.currentUser != null) {

    /* -------------------------------------------------------------------------- */
    /*                   SETUP OF HANDLING FOREGROUND MESSAGING                   */
    /* -------------------------------------------------------------------------- */

    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        // final NotificationsController notificationsController = Get.find();
        // await notificationsController.getNotifications();
        print(message.data["notification_type"]);
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }

      if (Platform.isIOS) {
        forgroundMessage(message);
      }
    });
    // }
  }

  /* -------------------------------------------------------------------------- */
  /*                              SHOW NOTIFICATION                             */
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*              IMPORATANT SETUP HERE TO HANDLE ANDROID CHANNELS              */
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*             FOR NOTIFICATION POP UP ON BACKGROUND AND TERMINATE            */
  /* -------------------------------------------------------------------------- */

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      // importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id, androidNotificationChannel.name,
      channelDescription: 'description',
      // channelAction: AndroidNotificationChannelAction.createIfNotExists,
      // channelAction: AndroidNotificationChannelAction.update,
/* -------------------------------------------------------------------------- */
/*               MOST IMPORTANT BASED STATUSES LIKE HIGH AND MAX              */
/* -------------------------------------------------------------------------- */
      priority: Priority.high,
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
/* -------------------------------------------------------------------------- */
/*                           SOUND WITHOUT EXTENSION                          */
/* -------------------------------------------------------------------------- */
      // sound: const RawResourceAndroidNotificationSound('sound'),
      // ticker: 'Ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
/* -------------------------------------------------------------------------- */
/*                FOR IOS WE USE DYNAMIC SOUND FROM SERVER-END                */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/*              FILE SHOULD BE PLACED IN RUNNER (XCODE) WITH REF              */
/* -------------------------------------------------------------------------- */
      // sound: 'sound1.mp3',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );

    if (message.data["is_voice"] == "1") {
      speak(message.notification!.title.toString());
    }
    // Print the payload
    print("Payload: ${message.data}");
  }

/* -------------------------------------------------------------------------- */
/*                  FLUTTER LOCAL NOTIFICATION INTIAlIZATION                  */
/* -------------------------------------------------------------------------- */
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
/* -------------------------------------------------------------------------- */
/*      IF ICON DRWABALE NOT SHOWING THEN CHECK ICON SIZE AND WITHOUT BG      */
/* -------------------------------------------------------------------------- */
    var androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');

    var iOSInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializeFlutterNotification = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(initializeFlutterNotification,
            onDidReceiveNotificationResponse: (payload) {
      handleMessageInteractionViaNotification(context, message);
    });
  }

/* -------------------------------------------------------------------------- */
/*                REQUEST resolvePlatformSpecificImplementation               */
/* -------------------------------------------------------------------------- */

  Future<void> requestPermissions() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              GET DEVICE TOKEN                              */
  /* -------------------------------------------------------------------------- */

  Future<String?> getDeviceToken() async => await firebaseMessaging.getToken();

  /* -------------------------------------------------------------------------- */
  /*                             SPEAK NOTIFICATION                             */
  /* -------------------------------------------------------------------------- */

  FlutterTts flutterTts = FlutterTts();
  Future<void> speak(String title) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    Future.delayed(const Duration(seconds: 2), () async {
      await flutterTts.speak(title);
    });
  }

  Future<void> setupInteractMessages(BuildContext context) async {
    /* -------------------------------------------------------------------------- */
    /*                           WHEN APP IS TERMINATED                           */
    /* -------------------------------------------------------------------------- */

    print('==================Getting Initial Message===================');

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessageInteractionViaNotification(context, initialMessage);
    }

    /* -------------------------------------------------------------------------- */
    /*                       WHEN APP IN BACKGROUND SERVICES                      */
    /* -------------------------------------------------------------------------- */

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('==================Getting Initial Message===================');
      handleMessageInteractionViaNotification(context, message);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*         HANDLE MESSAGE INTERACTION WHERE TO RE DIRECT SPECIFICALLY         */
  /* -------------------------------------------------------------------------- */

  void handleMessageInteractionViaNotification(
      BuildContext context, RemoteMessage message) async {
    String userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    if (userId.isEmpty) {
      Get.to(() => const SplashScreen());
    } else {
      Get.offAll(() => BottomNavBarScreen());
    }
  }

  // }
/* -------------------------------------------------------------------------- */
/*   IOS PLATFORM => SHOWING FOREGROUND MESSAGE TO PREVENT DOUBLE MESSAGING   */
/* -------------------------------------------------------------------------- */
  /* -------------------------------------------------------------------------- */
  /*                            GETTING SPEAK AS WELL                           */
  /* -------------------------------------------------------------------------- */

  Future forgroundMessage(RemoteMessage message) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (message.data["is_voice"] == "1") {
      speak(message.notification!.title.toString());
    }
  }
}
