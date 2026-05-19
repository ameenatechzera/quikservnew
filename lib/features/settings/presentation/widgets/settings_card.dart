import 'package:flutter/material.dart';
import 'package:quikservnew/features/accountGroups/presentation/screens/account_group_screen.dart';
import 'package:quikservnew/features/accountledger/presentation/screens/account_ledger_listing_screen.dart';
import 'package:quikservnew/features/authentication/presentation/screens/passwordchange_screen.dart';
import 'package:quikservnew/features/category/presentation/screens/category_listing_screen.dart';
import 'package:quikservnew/features/groups/presentation/screens/productgroup_listing_screen.dart';
import 'package:quikservnew/features/masters/presentation/screens/user_listing_screen.dart';
import 'package:quikservnew/features/products/presentation/screens/product_listing_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/aboutUs_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/loyalty_customer_creation.dart';
import 'package:quikservnew/features/settings/presentation/screens/loyalty_list_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/loyalty_save_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/print_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/sale_settings_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/settings_dashboard.dart';
import 'package:quikservnew/features/settings/presentation/screens/tokenreset_screen.dart';
import 'package:quikservnew/features/settings/presentation/widgets/dashboard_listtile.dart';
import 'package:quikservnew/features/settings/presentation/widgets/subscription_infocard.dart';
import 'package:quikservnew/features/units/presentation/screens/unit_listing_screen.dart';
import 'package:quikservnew/features/vat/presentation/screens/vat_listing_screen.dart';
bool _loyaltyEnabled = false;
class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key, required this.isBasic});

  final bool isBasic;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  if (!widget.isBasic)
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
                    page: PrintSettingsScreen(companyName: st_companyName),
                    // page: PrinterSettingsContent(
                    //   companyName: st_companyName,
                    // ),
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
            //Loyalty
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      "Loyalty Card",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  // After the header card SizedBox(height: 24), add:

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [

                        Text(
                          'Enable Loyalty Card',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _loyaltyEnabled
                                ? const Color(0xFF1565C0)
                                : const Color(0xFF546E7A),
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _loyaltyEnabled,
                          onChanged: (val) => setState(() => _loyaltyEnabled = val),
                          activeColor: const Color(0xFF1565C0),
                        ),


                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                    buildTile(
                      context: context,
                      icon: Icons.card_giftcard,
                      title: "Add Loyalty Card",
                      page: LoyaltyListPage(),
                    ),
                  buildTile(
                    context: context,
                    icon: Icons.person_outline,
                    title: "Add Loyalty Customer",
                    page: AddLoyaltyCustomer(),
                    // page: PrinterSettingsContent(
                    //   companyName: st_companyName,
                    // ),
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
                  if (!widget.isBasic)
                    buildTile(
                      context: context,
                      icon: Icons.group_add_outlined,
                      title: "User Creation",
                      page: UsersListScreen(),
                    ),
                  if (!widget.isBasic)
                    buildTile(
                      context: context,
                      icon: Icons.account_box,
                      title: "Account Group",
                      page: AccountGroupListingScreen(),
                    ),
                  if (!widget.isBasic)
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
                  Visibility(
                    visible: vatStatus,
                    child: buildTile(
                      context: context,
                      icon: Icons.money,
                      title: "Tax",
                      page: VatsListingScreen(),
                    ),
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
                    page: AboutScreen(),
                  ),
                  InkWell(
                    onTap: () {
                      showLogoutDialog(context, () {
                        // Your logout logic
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
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
    );
  }
}
