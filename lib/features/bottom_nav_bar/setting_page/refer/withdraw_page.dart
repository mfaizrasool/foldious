import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class WithDrawPage extends StatefulWidget {
  const WithDrawPage({super.key});
  @override
  State<WithDrawPage> createState() => _WithDrawPageState();
}

class _WithDrawPageState extends State<WithDrawPage> {
  final UserDetailsController userDetailsController = Get.find();
  final MyEarningController controller = Get.find();

  ///
  ///
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();

  ///
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode accountFocusNode = FocusNode();

  ///
  ///

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Obx(() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: PrimaryAppBar(
            title: AppLabels.myEarning,
          ),
          body: userDetailsController.isLoading.value ||
                  controller.isLoading.value
              ? LoadingIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.02),
                          Text(
                            'Payment Method',
                            style: AppTextStyle.bodyMedium,
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            width: width,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: controller.selectedPaymentMethod.value,
                              onChanged: (String? newValue) {
                                controller.selectedPaymentMethod.value =
                                    newValue!;
                              },
                              items: controller.paymentMethods
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              iconSize: 30,
                            ),
                          ),
                          SizedBox(height: height * 0.02),

                          ///
                          ///
                          ///

                          if (controller.selectedPaymentMethod.value ==
                              controller.paymentMethods.first)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Bank',
                                  style: AppTextStyle.bodyMedium,
                                ),
                                SizedBox(height: height * 0.01),
                                Container(
                                  width: width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: DropdownButton<String>(
                                    value: controller.selectedBank.value,
                                    onChanged: (String? newValue) {
                                      controller.selectedBank.value = newValue!;
                                    },
                                    items: controller.bankList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    iconSize: 30,
                                  ),
                                )
                              ],
                            ),

                          ///
                          ///
                          ///
                          PrimaryTextField(
                            label: "Account Title",
                            hintText: "Enter your account title",
                            controller: nameController,
                            focusNode: nameFocusNode,
                            mandatory: true,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(accountFocusNode);
                            },
                          ),

                          ///
                          ///
                          ///
                          PrimaryTextField(
                            label: controller.selectedPaymentMethod.value ==
                                    controller.paymentMethods.first
                                ? "Account number"
                                : "Mobile Number",
                            hintText: controller.selectedPaymentMethod.value ==
                                    controller.paymentMethods.first
                                ? "Enter account number"
                                : "Enter mobile number",
                            controller: accountNumber,
                            focusNode: accountFocusNode,
                            mandatory: true,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          SizedBox(height: height * 0.1),

                          Center(
                            child: Text(
                              'Total Earnings: ${controller.myEarning.earnings ?? 0} PKR',
                              style: AppTextStyle.titleSmall,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Center(
                            child: PrimaryButton(
                              title: "Withdraw",
                              enabled:
                                  (controller.myEarning.earnings ?? 0) >= 100
                                      ? true
                                      : false,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (controller.selectedPaymentMethod.value ==
                                        controller.paymentMethods.first &&
                                    controller.selectedBank.value ==
                                        controller.bankList.first) {
                                  showErrorMessage('Select Bank Account');
                                } else if (nameController.text.isEmpty) {
                                  showErrorMessage(
                                      'Account Title cannot be empty.');
                                } else if (accountNumber.text.isEmpty) {
                                  showErrorMessage(
                                      'Account Number cannot be empty.');
                                } else {
                                  controller.withdrawEarning(
                                    name: nameController.text,
                                    account: accountNumber.text,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.02),

                          ///
                          ///
                          ///
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
