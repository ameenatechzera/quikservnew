import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/settings/presentation/widgets/salesettings_widgets.dart';

class SaleSettingsScreen extends StatelessWidget {
  const SaleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3F6),
      appBar: const CommonAppBar(title: "Sale Settings"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                cursorFocusSection(),
                const SizedBox(height: 16),
                itemTapBehaviorSection(),
                const SizedBox(height: 16),
                paymentOptionsSection(),
              ],
            ),
          ),

          /// BOTTOM ACTIONS
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: actionButton(
                    label: "CANCEL",
                    color: Colors.grey.shade300,
                    textColor: Colors.black87,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: actionButton(
                    label: "SAVE",
                    color: AppColors.primary,
                    textColor: AppColors.black,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
