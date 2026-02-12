import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/accountGroups/presentation/screens/account_group_screen.dart';
import 'package:quikservnew/features/accountledger/presentation/screens/account_ledger_listing_screen.dart';
import 'package:quikservnew/features/authentication/presentation/screens/login_screen.dart';
import 'package:quikservnew/features/category/presentation/screens/category_listing_screen.dart';
import 'package:quikservnew/features/masters/presentation/screens/user_listing_screen.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/screens/product_listing_screen.dart';
import 'package:quikservnew/features/groups/presentation/screens/productgroup_listing_screen.dart';
import 'package:quikservnew/features/authentication/presentation/screens/passwordchange_screen.dart';
import 'package:quikservnew/features/units/presentation/screens/unit_listing_screen.dart';
// import 'package:quikservnew/features/masters/presentation/screens/user_listing_screen.dart';
import 'package:quikservnew/features/vat/presentation/screens/vat_listing_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/printer_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/sale_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/tokenResetScreen.dart';
import 'package:quikservnew/features/settings/presentation/widgets/dashboard_listtile.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

import 'aboutUs_screen.dart';
String st_companyName ='';
class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});

  Future<String?> _getAppVersion() async {
    return await SharedPreferenceHelper().getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        final appVersion = snapshot.data ?? "";
        print('appVersion $appVersion');

        final bool isBasic = appVersion.toLowerCase() == "basic";


        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            title: const Text(
              "Configurations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.theme,
          ),
          body: Column(
            children: [
              SubscriptionInfoCard(), // 👈 top card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      /// SETTINGS CARD
                      Card(
                        child: Column(
                          children: [
                            const ListTile(
                              title: Text(
                                "Settings",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (!isBasic)
                              buildTile(
                                context: context,
                                icon: Icons.person_outline,
                                title: "Account Settings",
                                page: AccountSettingsScreen(),
                              ),
                            buildTile(
                              context: context,
                              icon: Icons.print_outlined,
                              title: "Print Settings",
                              page: PrinterSettingsContent(companyName: st_companyName,),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.receipt_long_outlined,
                              title: "Sales Settings",
                              page: SaleSettingsScreen(),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.token_outlined,
                              title: "Reset Token",
                              page: ResetTokenScreen(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// MASTERS CARD
                      Card(
                        child: Column(
                          children: [
                            const ListTile(
                              title: Text(
                                "Masters",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.account_box,
                              title: "Change Password",
                              page: PasswordChangeScreen(),
                            ),
                            if (!isBasic)
                              buildTile(
                                context: context,
                                icon: Icons.group_add_outlined,
                                title: "User Creation",
                                page: UsersListScreen(),
                              ),
                            if (!isBasic)
                              buildTile(
                                context: context,
                                icon: Icons.account_box,
                                title: "Account Group",
                                page: AccountGroupListingScreen(),
                              ),
                            if (!isBasic)
                              buildTile(
                                context: context,
                                icon: Icons.account_box,
                                title: "Account Ledger",
                                page: const AccountLedgerListingScreen(),
                              ),
                            buildTile(
                              context: context,
                              icon: Icons.monitor_weight,
                              title: "Unit",
                              page: UnitsListingScreen(),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.money,
                              title: "Tax",
                              page: VatsListingScreen(),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.production_quantity_limits_outlined,
                              title: "Product",
                              page: const ProductListingScreen(),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.production_quantity_limits,
                              title: "Product Group",
                              page: ProductgroupListingScreen(),
                            ),
                            buildTile(
                              context: context,
                              icon: Icons.category,
                              title: "Category",
                              page: CategoriesListingScreen(),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            buildTile(
                              context: context,
                              icon: Icons.contact_mail,
                              title: "Contact Us",
                              page: const AboutScreen(),
                            ),
                            InkWell(
                              onTap: () {
                                showLogoutDialog(context, () {
                                  // Your logout logic
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                 // mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.logout, color: Colors.red),
                                    SizedBox(width: 15),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
Future<void> showLogoutDialog(
    BuildContext parentContext,
    VoidCallback onConfirm,
    ) {
  return showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appThemeRemoveColors,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () async {
              // 👇 Capture cubit BEFORE UI changes
              //final productCubit = parentContext.read<ProductCubit>();

              Navigator.pop(dialogContext); // close dialog

              onConfirm(); // optional external logic

              // Clear local storage
              await SharedPreferenceHelper().setToken('');
              await SharedPreferenceHelper().setBranchId('');
              await SharedPreferenceHelper().setSubscriptionCode('');

              // Clear cubit safely (no more context usage)
            //  await productCubit.clearProducts();

              if (!parentContext.mounted) return;
              await SharedPreferenceHelper().setLogoutStatus(
                'true',
              );
              Navigator.of(parentContext).push(
                MaterialPageRoute(builder: (_) =>  LoginScreen()),

              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}




class SubscriptionInfoCard extends StatelessWidget {
  const SubscriptionInfoCard({super.key});

  Future<Map<String, String>> _loadData() async {
    final prefs = SharedPreferenceHelper();
    st_companyName = await prefs.getCompanyName() ?? '';
    return {
      'companyName': await prefs.getCompanyName() ?? '',
      'subCode': await prefs.getSubscriptionCode(),
      'expiryDate': await prefs.getExpiryDate(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final data = snapshot.data!;
        final companyName = data['companyName']!;
        final subCode = data['subCode']!;
        final expiryDate = data['expiryDate']!;
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1C1), // light yellow background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Main circular logo
                      Container(
                        width: 78,
                        height: 78,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0B3D3B),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      // Edit icon (bottom-right)
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                              size: 13,
                              color: Color(0xFF0B3D3B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            companyName.isEmpty ? '—' : companyName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ID Row
                        Row(
                          children: [
                            Icon(
                              Icons.subscriptions,
                              size: 20,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 4),
                            Text(
                              subCode,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Warning Message
                      ],
                    ),
                  ),
                ],
              ),
              if (expiryDate.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Your Subscription Will End On $expiryDate..',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
