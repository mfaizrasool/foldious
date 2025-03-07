import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_model.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/withdraw_status_model.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class MyEarningController extends GetxController {
  var isLoading = false.obs;
  var isReferralDialog = false.obs;

  ///
  RxString selectedPaymentMethod = "Bank Account".obs;
  final List<String> paymentMethods = ['Bank Account', 'EasyPaisa', 'JazzCash'];

  ///
  RxString selectedBank = "Select".obs;
  final List<String> bankList = [
    'Select',
    'ABL',
    'Askari Bank',
    'Bank Al-Habib Ltd.',
    'Bank Alfalah',
    'Bank Islami',
    'FWBL',
    'Dubai Islamic',
    'HBL',
    'Habib Metro',
    'JS Bank',
    'MCB',
    'MCB Islamic',
    'Meezan',
    'Samba',
    'Silk Bank',
    'Sindh Bank',
    'Soneri Bank Ltd.',
    'Standard Chartered',
    'Summit Bank',
    'BOK',
    'UBL',
    'BOP',
    'Faysal Bank',
    'NBP',
    'Bank of China',
    'ICBC',
    'Citi Bank',
    'SME Bank',
    'Al-Baraka Bank',
    'PPCBL',
    'Deutsche',
    'IDBL',
  ];

  @override
  void onInit() {
    getMyEarning();
    super.onInit();
  }

  MyEarningModel myEarning = MyEarningModel();
  Future<void> getMyEarning() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 0));
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);
      final result = await Get.find<NetworkClient>().get(
        ApiUrls.referalListView,
        queryParameters: {'user_id': userId},
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        myEarning = MyEarningModel.fromJson(result.rawData);
      } else {
        showErrorMessage(result.error ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  WithdrawStatusModel withdrawStatusModel = WithdrawStatusModel();
  Future<void> withdrawStatus() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 0));
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);
      final result = await Get.find<NetworkClient>().get(
        ApiUrls.withdrawStatus,
        queryParameters: {'user_id': userId},
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        withdrawStatusModel = WithdrawStatusModel.fromJson(result.rawData);
      } else {
        showErrorMessage(result.error ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  Future<void> withdrawEarning({
    required String name,
    required String account,
  }) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 0));
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);
      String idsToSend = "";
      for (var user in myEarning.userData!) {
        if (user.userReferalAmount == "0" && user.userId != null) {
          if (idsToSend.isNotEmpty) {
            idsToSend += ",";
          }
          idsToSend += user.userId!;
        }
      }

      print("idsToSend ==> $idsToSend");

      var payload = {
        "user_id": userId,
        "withdraw_amount": myEarning.earnings.toString(),
        "withdraw_method": selectedPaymentMethod.value,
        "withdraw_account_name": name,
        "withdraw_account_number": account,
        "referal_users": idsToSend,
      };

      ///
      final result = await Get.find<NetworkClient>().post(
        ApiUrls.requestWithdraw,
        data: payload,
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        myEarning = MyEarningModel.fromJson(result.rawData);
        Get.back();
      } else {
        showErrorMessage(result.error ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  Future<void> addReferal({
    required String code,
  }) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 0));
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);

      var payload = {"user_id": userId, "referal_code": code};

      ///
      final result = await Get.find<NetworkClient>().post(
        ApiUrls.addReferal,
        data: payload,
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        Get.back();
        showSuccessMessage("Referal code added successfully");
      } else {
        showErrorMessage(result.error ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
