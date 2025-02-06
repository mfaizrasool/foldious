import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notifications_model.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var selectedNotifications = <String>[].obs;
  var isSelectionMode = false.obs;

  NotificationsModel notificationsModel = NotificationsModel();

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;

      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);
      var payload = {"user_id": userId};

      final result = await Get.find<NetworkClient>().post(
        ApiUrls.getNotifications,
        data: payload,
      );

      if (result.isSuccess) {
        var data = result.rawData;
        notificationsModel = NotificationsModel.fromJson(data);
      } else {
        showErrorMessage(result.error ?? result.message ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNotificationStatus(String notificationId) async {
    try {
      isLoading.value = true;
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);

      var payload = {
        "user_id": userId,
        "notification_ids": notificationId,
      };

      final result = await Get.find<NetworkClient>().post(
        ApiUrls.updateNotificationStatus,
        data: payload,
      );

      if (result.isSuccess) {
        await getNotifications();
      } else {
        showErrorMessage(result.error ?? result.message ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMultipleNotifications() async {
    if (selectedNotifications.isEmpty) return;

    try {
      isLoading.value = true;
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);

      var payload = {
        "user_id": userId,
        "notification_ids": selectedNotifications.join(','),
      };

      final result = await Get.find<NetworkClient>().post(
        ApiUrls.updateNotificationStatus,
        data: payload,
      );

      if (result.isSuccess) {
        selectedNotifications.clear();
        isSelectionMode.value = false;
        await getNotifications();
      } else {
        showErrorMessage(result.error ?? result.message ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNotificationSelection(String id) {
    if (selectedNotifications.contains(id)) {
      selectedNotifications.remove(id);
    } else {
      selectedNotifications.add(id);
    }
    if (selectedNotifications.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedNotifications.clear();
  }

  void toggleSelectAll() {
    if (selectedNotifications.length ==
        notificationsModel.notifications?.length) {
      // If all are selected, unselect all
      selectedNotifications.clear();
      isSelectionMode.value = false;
    } else {
      // Select all notifications
      selectedNotifications.clear();
      notificationsModel.notifications?.forEach((notification) {
        selectedNotifications.add(notification.id.toString());
      });
    }
  }
}
