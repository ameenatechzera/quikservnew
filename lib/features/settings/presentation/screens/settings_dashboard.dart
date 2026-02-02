import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/accountGroups/presentation/screens/account_group_screen.dart';
import 'package:quikservnew/features/accountledger/presentation/screens/account_ledger_listing_screen.dart';
import 'package:quikservnew/features/category/presentation/screens/category_listing_screen.dart';
import 'package:quikservnew/features/products/presentation/screens/product_listing_screen.dart';
import 'package:quikservnew/features/groups/presentation/screens/productgroup_listing_screen.dart';
import 'package:quikservnew/features/units/presentation/screens/unit_listing_screen.dart';
import 'package:quikservnew/features/masters/presentation/screens/user_listing_screen.dart';
import 'package:quikservnew/features/vat/presentation/screens/vat_listing_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/printer_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/sale_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/tokenResetScreen.dart';
import 'package:quikservnew/features/settings/presentation/widgets/dashboard_listtile.dart';

import 'aboutUs_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          subscriptionInfoCard(), // 👈 top card
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
                        buildTile(
                          context: context,
                          icon: Icons.person_outline,
                          title: "Account Settings",
                          page: AccountSettingsScreen(),
                        ),
                        buildTile(
                          context: context,
                          icon: Icons.print_outlined,
                          title: "Printer Settings",
                          page: const PrinterSettingsContent(),
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
                          icon: Icons.group_add_outlined,
                          title: "User Creation",
                          page: UsersListScreen(),
                        ),
                        buildTile(
                          context: context,
                          icon: Icons.account_box,
                          title: "Account Group",
                          page: AccountGroupListingScreen(),
                        ),
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
                          title: "Vat",
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
                    child: buildTile(
                      context: context,
                      icon: Icons.contact_mail,
                      title: "Contact Us",
                      page: const AboutScreen(),
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

Widget subscriptionInfoCard() {
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
                    child: const Text(
                      'Grin Table',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ID Row
                  Row(
                    children: const [
                      Icon(
                        Icons.subscriptions,
                        size: 20,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '324',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Your Subscription Will End On 21 September 2026.',
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
}
