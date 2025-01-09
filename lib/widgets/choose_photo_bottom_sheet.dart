import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';

class ChoosePhotoBottomSheet extends StatelessWidget {
  const ChoosePhotoBottomSheet({
    super.key,
    required this.onTakePhotoPressed,
    required this.onChooseFromLibraryPressed,
  });

  final VoidCallback onTakePhotoPressed;
  final VoidCallback onChooseFromLibraryPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: appTheme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appTheme.colorScheme.secondaryContainer,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Upload a photo',
              style: AppTextStyle.bodyMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          InkWell(
            onTap: onChooseFromLibraryPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.now_wallpaper_sharp,
                    size: 24.0,
                    color: appTheme.iconTheme.color,
                  ),
                  const SizedBox(width: 24.0),
                  Text(
                    'Choose from library',
                    style: AppTextStyle.titleMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onTakePhotoPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12.0,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 24.0,
                    color: appTheme.iconTheme.color,
                  ),
                  const SizedBox(width: 24.0),
                  Text(
                    'Take Photo',
                    style: AppTextStyle.titleMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
