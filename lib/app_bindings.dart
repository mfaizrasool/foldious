import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notifications_controller.dart';
import 'package:foldious/utils/theme/theme_controller.dart';
import 'package:foldious/widgets/internet_check_connectivity.dart';
import 'package:get/get.dart';

BindingsBuilder createBindings(BuildContext context) {
  return BindingsBuilder(() {
    Get.put(ThemeController(), permanent: true);
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<NetworkClient>(
      NetworkClient(
        getUserAuthToken: () async {
          final auth = Get.find<FirebaseAuth>();
          if (auth.currentUser != null) {
            final authToken = await auth.currentUser!.getIdToken();
            return authToken;
          }
          return null;
        },
      ),
      permanent: true,
    );
    Get.put(InternetConnectionController(), permanent: true);
    Get.put(AppPreferencesController(), permanent: true);
    Get.put(UserDetailsController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
  });
}
