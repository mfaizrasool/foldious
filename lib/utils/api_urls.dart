class ApiUrls {
  static const String baseUrl = "https://foldious.com/api";
  static const String counterUpload =
      "https://drive.foldious.com/counter-upload.php";
  static const String profilePath = "https://foldious.com/api/dp/";

  ///
  ///
  ///
  static const String botToken =
      "7147572018:AAF_uX7c5FbA_V5DoglL1AuQbtHTWnix1Yg";
  static const String dowloadUrl =
      "https://api.telegram.org/file/bot$botToken/";

  ///
  static const String webViewVideoPath =
      "https://drive.foldious.com/downloader.php?file_access_key=";

  ///
  static const String login = "/authentication/login.php";
  static const String register = "/authentication/register.php";
  static const String forgetPassword = "/authentication/forget_password.php";
  static const String userDetails = "/authentication/user_details.php";
  static const String addDP = "/authentication/dp.php";
  static const String profileUpdate = "/authentication/profile_update.php";
  static const String userImageUpdate = "/authentication/userimage_update.php";
  static const String updatePassword = "/authentication/update_password.php";
  static const String deleteUser = "/authentication/delete_user.php";

  /* -------------------------------------------------------------------------- */
  /*                                   folder                                   */
  /* -------------------------------------------------------------------------- */
  static const String type = "/folder/type.php";
  static const String dataView = "/folder/data_view.php";
  static const String fileDetails = "/folder/file_details.php";
  static const String trash = "/folder/trash.php";

  /* -------------------------------------------------------------------------- */
  /*                                notifications                               */
  /* -------------------------------------------------------------------------- */
  static const String getNotifications = "/notification/get_notifications.php";
  static const String updateNotificationStatus =
      "/notification/update_notification_status.php";

  /* -------------------------------------------------------------------------- */
  /*                                    refer                                   */
  /* -------------------------------------------------------------------------- */
  static const String referalListView = "/referal/referal_list_view.php";
}
