import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/account_group_listing_screen.dart';
import 'package:quikservnew/features/masters/presentation/screens/account_ledger_listing_screen.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                    page: const AccountSettingsScreen(),
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
                    page: const UsersListScreen(),
                  ),
                  buildTile(
                    context: context,
                    icon: Icons.account_box,
                    title: "Account Group",
                    page: const AccountGroupsListingScreen(),
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
          ],
        ),
      ),
    );
  }
}
