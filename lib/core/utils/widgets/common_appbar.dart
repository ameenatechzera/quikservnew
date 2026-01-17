import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40); // ✅ FIXED HEIGHT

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40, // ✅ IMPORTANT
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.theme,
      elevation: 0,
      leading: showBack
          ? IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                fontWeight: FontWeight.w600,

                size: 18,
                color: AppColors.black,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          //fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }
}
