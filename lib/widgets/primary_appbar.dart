import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final bool showBackArrowIcon;
  final double elevation;
  final List<Widget>? actions;
  final bool showEditButton;
  final VoidCallback? onEditTapped;
  final PreferredSizeWidget? bottomWidget;
  final Widget? leadingWidget;
  final Color? backgroundColor;

  const PrimaryAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.titleWidget,
    this.centerTitle = true,
    this.showBackArrowIcon = true,
    this.elevation = 1.0,
    this.actions,
    this.showEditButton = false,
    this.onEditTapped,
    this.bottomWidget,
    this.leadingWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.appBarTheme.backgroundColor,
      elevation: elevation,
      title: titleWidget ??
          Text(
            title ?? '',
            style: appTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 17.0,
              color: appTheme.iconTheme.color,
            ),
          ),
      centerTitle: centerTitle,
      leading: showBackArrowIcon
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: appTheme.iconTheme.color,
                ),
              ),
            )
          : (leadingWidget ?? Container()),
      bottom: bottomWidget,
      leadingWidth: leadingWidget != null ? Get.width * 0.3 : null,
      actions: showEditButton
          ? [
              InkWell(
                onTap: onEditTapped,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Edit",
                        textAlign: TextAlign.right,
                        style: appTheme.textTheme.bodyMedium?.copyWith(
                          color: appTheme.primaryColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]
          : actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
