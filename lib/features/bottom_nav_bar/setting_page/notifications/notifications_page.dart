import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notifications_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/notifications/notifications_model.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final UserDetailsController userDetailsController = Get.find();
  final NotificationsController controller = Get.find();

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void getNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return Scaffold(
          appBar: controller.isSelectionMode.value
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.exitSelectionMode,
                  ),
                  title: Text(
                      '${controller.selectedNotifications.length} Selected'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      onPressed: () => controller.toggleSelectAll(),
                    ),
                    if (controller.selectedNotifications.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: controller.updateMultipleNotifications,
                      ),
                  ],
                )
              : PrimaryAppBar(
                  title: AppLabels.notifications,
                  centerTitle: true,
                ),
          body: Stack(
            children: [
              SafeArea(
                child: controller.notificationsModel.notifications!.isEmpty
                    ? Center(
                        child: Text(
                          "No New notifications found",
                          style: AppTextStyle.bodyMedium,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.notificationsModel
                                        .notifications?.length ??
                                    0,
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.02),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Notifications notification = controller
                                      .notificationsModel.notifications![index];
                                  bool isSelected = controller
                                      .selectedNotifications
                                      .contains(notification.id.toString());

                                  return Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.02),
                                    child: InkWell(
                                      onTap: () {
                                        if (controller.isSelectionMode.value) {
                                          controller
                                              .toggleNotificationSelection(
                                                  notification.id.toString());
                                        } else if (notification.isRead == "0") {
                                          controller.updateNotificationStatus(
                                              notification.id.toString());
                                        }
                                      },
                                      onLongPress: () {
                                        if (!controller.isSelectionMode.value) {
                                          controller.isSelectionMode.value =
                                              true;
                                          controller
                                              .toggleNotificationSelection(
                                                  notification.id.toString());
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.greyColor
                                              .withValues(alpha: 0.3),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (controller
                                                  .isSelectionMode.value)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: Icon(
                                                    isSelected
                                                        ? Icons.check_circle
                                                        : Icons.circle_outlined,
                                                  ),
                                                ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      notification.title ?? "",
                                                      style: AppTextStyle
                                                          .titleSmall
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.01),
                                                    Text(
                                                      notification.body ?? "",
                                                      style: AppTextStyle
                                                          .titleSmall
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (notification.isRead == "0")
                                                Container(
                                                  height: height * 0.01,
                                                  width: height * 0.01,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.red,
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              if (controller.isLoading.value ||
                  userDetailsController.isLoading.value)
                const LoadingIndicator(),
            ],
          ),
        );
      }),
    );
  }
}
