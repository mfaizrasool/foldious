import 'package:flutter/material.dart';
import 'package:foldious/common/ads/ads_controller.dart';
import 'package:foldious/common/controllers/get_files_controller.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/home_page.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notification_setup.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notifications_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/setting_page.dart';
import 'package:foldious/features/bottom_nav_bar/trash/trash.dart';
import 'package:foldious/features/bottom_nav_bar/upload_page/upload_page.dart';
import 'package:foldious/features/bottom_nav_bar/user_page/user_page.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'home_page/home_controller.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});
  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  final HomeController homeController = Get.put(HomeController());
  final FileTypeController fileTypeController = Get.put(FileTypeController());
  final NotificationsController notificationsController = Get.find();
  @override
  void initState() {
    notificationSetup();
    super.initState();
  }

  void notificationSetup() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /* -------------------------------------------------------------------------- */
      /*                             NOTIFICATION SETUP                             */
      /* -------------------------------------------------------------------------- */

      NotificationSetup().firebaseNontificationInit(context);
      NotificationSetup().setupInteractMessages(context);
      NotificationSetup().requestPermissions();
      notificationsController.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    // double width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          PersistentTabView(
            navBarHeight: height * 0.08,
            navBarBuilder: (navBarConfig) =>
                Style14BottomNavBar(navBarConfig: navBarConfig),
            onTabChanged: (index) async {
              if (index == 0) {
                print("index == $index");
                homeController.fetchUserDetails();
              } else if (index == 1) {
                print("index == $index");
                fileTypeController.allFilesPagination.clear();
                fileTypeController.currentPage.value = 1;
                await fileTypeController.getTrashFiles(
                  showpaginationLoader: false,
                );
              } else if (index == 2) {
                print("index == $index");
                UnityAdsController unityAdsController = Get.find();
                unityAdsController.showUnityAdAndNavigate(() {});
              }
            },
            tabs: [
              PersistentTabConfig(
                screen: const HomePage(),
                item: ItemConfig(
                  icon: const Icon(Icons.home),
                  activeForegroundColor: AppColors.primaryColor,
                  inactiveForegroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.5),
                  title: AppLabels.home,
                  textStyle: AppTextStyle.titleSmall,
                ),
              ),
              PersistentTabConfig(
                screen: const TrashScreen(),
                item: ItemConfig(
                  icon: const Icon(Icons.delete_forever_outlined),
                  activeForegroundColor: AppColors.primaryColor,
                  inactiveForegroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.5),
                  title: AppLabels.trash,
                  textStyle: AppTextStyle.titleSmall,
                ),
              ),
              PersistentTabConfig(
                screen: UploadPage(),
                item: ItemConfig(
                  icon: Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  activeForegroundColor: Colors.transparent,
                ),
              ),
              PersistentTabConfig(
                screen: const UserPage(),
                item: ItemConfig(
                  icon: const Icon(Icons.person),
                  activeForegroundColor: AppColors.primaryColor,
                  inactiveForegroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.5),
                  title: AppLabels.user,
                  textStyle: AppTextStyle.titleSmall,
                ),
              ),
              PersistentTabConfig(
                screen: const SettingPage(),
                item: ItemConfig(
                  icon: const Icon(Icons.settings),
                  activeForegroundColor: AppColors.primaryColor,
                  inactiveForegroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.5),
                  title: AppLabels.setting,
                  textStyle: AppTextStyle.titleSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
