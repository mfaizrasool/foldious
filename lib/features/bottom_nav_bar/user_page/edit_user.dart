import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/user_page/user_controller.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/choose_photo_bottom_sheet.dart';
import 'package:foldious/widgets/loading_image.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final UserController controller = Get.put(UserController());
  final UserDetailsController userDetailsController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  ///
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    nameController.text = userDetailsController.userDetails.userName ?? "";
    phoneController.text = userDetailsController.userDetails.userContact ?? "";
    ageController.text = userDetailsController.userDetails.userAge ?? "";
    addressController.text =
        userDetailsController.userDetails.userAddress ?? "";

    // Ensure selectedGender has a valid default value
    final userGender = userDetailsController.userDetails.userGender;
    if (userGender != null && controller.gendersList.contains(userGender)) {
      controller.selectedGender.value = userGender;
    } else {
      controller.selectedGender.value = controller.gendersList.last;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageFocusNode.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppLabels.editUser,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.03),
                        SizedBox(
                          width: height * 0.15,
                          height: height * 0.15,
                          child: Stack(
                            children: [
                              /// Profile Image Container
                              Container(
                                width: height * 0.15,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: appTheme
                                          .colorScheme.secondaryContainer,
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: LoadingImage(
                                  imageUrl: userDetailsController.userDetails
                                              .userImage?.isNotEmpty ==
                                          true
                                      ? ApiUrls.profilePath +
                                          userDetailsController
                                              .userDetails.userImage!
                                      : "https://cdn-icons-png.flaticon.com/512/219/219988.png",
                                  fit: BoxFit.cover,
                                ),
                              ),

                              /// Edit Icon
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context);
                                  },
                                  child: Container(
                                    width: height * 0.05,
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///
                        ///
                        ///
                        SizedBox(height: height * 0.03),

                        /// Name
                        PrimaryTextField(
                          label: AppLabels.fullName,
                          hintText: AppLabels.enterFullName,
                          controller: nameController,
                          focusNode: nameFocusNode,
                          mandatory: true,
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(phoneFocusNode);
                          },
                        ),

                        /// Phone
                        PrimaryTextField(
                          label: AppLabels.phoneNumber,
                          hintText: AppLabels.phoneNumber,
                          controller: phoneController,
                          focusNode: phoneFocusNode,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(ageFocusNode);
                          },
                        ),

                        /// Age
                        PrimaryTextField(
                          label: AppLabels.age,
                          hintText: AppLabels.ageHint,
                          controller: ageController,
                          focusNode: ageFocusNode,
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(addressFocusNode);
                          },
                        ),

                        SizedBox(height: height * 0.01),

                        /// Address
                        PrimaryTextField(
                          label: AppLabels.address,
                          hintText: AppLabels.addressHint,
                          focusNode: addressFocusNode,
                          controller: addressController,
                        ),

                        ///
                        ///
                        /// Gender Dropdown
                        SizedBox(height: height * 0.01),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: AppLabels.selectGender,
                              style: appTheme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        DropdownButtonFormField<String>(
                          value: controller.selectedGender.value.isNotEmpty
                              ? controller.selectedGender.value
                              : null, // Null-safe default
                          items: controller.gendersList.map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            controller.selectedGender.value = newValue!;
                          },
                          validator: (value) =>
                              value == null ? "Gender is required" : null,
                        ),

                        SizedBox(height: height * 0.03),

                        /// Update Button
                        PrimaryButton(
                          title: AppLabels.update,
                          onPressed: () async {
                            await controller.profileUpdate(
                              userName: nameController.text,
                              userImage:
                                  userDetailsController.userDetails.userImage ??
                                      "",
                              userAddress: addressController.text,
                              userContact: phoneController.text,
                              userGender: controller.selectedGender.value,
                              userAge: ageController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isLoading.value ||
                  userDetailsController.isLoading.value)
                LoadingIndicator(),
            ],
          );
        }),
      ),
    );
  }

  /// Show Bottom Sheet for Image Selection
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ChoosePhotoBottomSheet(
        onChooseFromLibraryPressed: () =>
            _chooseImage(context, ImageSource.gallery),
        onTakePhotoPressed: () => _chooseImage(context, ImageSource.camera),
      ),
    );
  }

  /// Image Selection Logic
  Future<void> _chooseImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    await controller.getImage(source);
  }
}
