import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/settings/presentation/widgets/salesettings_widgets.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SaleSettingsScreen extends StatefulWidget {
  const SaleSettingsScreen({super.key});

  @override
  State<SaleSettingsScreen> createState() => _SaleSettingsScreenState();
}

class _SaleSettingsScreenState extends State<SaleSettingsScreen> {
  int selectedItemTapBehavior = 1;
  int selectedPaymentOption = 0;

  final SharedPreferenceHelper helper = SharedPreferenceHelper();

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    selectedItemTapBehavior = await helper.getItemTapBehavior();
    selectedPaymentOption = await helper.getPaymentOption();
    setState(() {});
  }

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
                // cursorFocusSection(),
                // const SizedBox(height: 16),
                itemTapBehaviorSection(
                  selectedValue: selectedItemTapBehavior,
                  onChanged: (value) {
                    setState(() {
                      selectedItemTapBehavior = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                paymentOptionsSection(
                  selectedValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value;
                    });
                  },
                ),
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
                    onTap: () async {
                      await helper.saveItemTapBehavior(selectedItemTapBehavior);
                      await helper.savePaymentOption(selectedPaymentOption);
                      Navigator.pop(context);
                    },
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
// import 'package:flutter/material.dart';
// import 'package:quikservnew/core/theme/colors.dart';
// import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
// import 'package:quikservnew/features/settings/presentation/widgets/salesettings_widgets.dart';
// import 'package:quikservnew/services/shared_preference_helper.dart';

// class SaleSettingsScreen extends StatefulWidget {
//   const SaleSettingsScreen({super.key});

//   @override
//   State<SaleSettingsScreen> createState() => _SaleSettingsScreenState();
// }

// class _SaleSettingsScreenState extends State<SaleSettingsScreen> {
//   int selectedItemTapBehavior = 1;
//   final SharedPreferenceHelper helper = SharedPreferenceHelper();
//   @override
//   void initState() {
//     super.initState();
//     _loadSaved();
//   }

//   Future<void> _loadSaved() async {
//     selectedItemTapBehavior = await helper.getItemTapBehavior();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDF3F6),
//       appBar: const CommonAppBar(title: "Sale Settings"),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 itemTapBehaviorSection(
//                   selectedValue: selectedItemTapBehavior,
//                   onChanged: (value) {
//                     // ✅ ONLY update local state
//                     setState(() {
//                       selectedItemTapBehavior = value;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 paymentOptionsSection(),
//               ],
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: actionButton(
//                     label: "CANCEL",
//                     color: Colors.grey.shade300,
//                     textColor: Colors.black87,
//                     onTap: () => Navigator.pop(context),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: actionButton(
//                     label: "SAVE",
//                     color: AppColors.primary,
//                     textColor: AppColors.black,
//                     onTap: () async {
//                       // ✅ ONLY HERE we save to SharedPreferences
//                       await helper.saveItemTapBehavior(selectedItemTapBehavior);
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
