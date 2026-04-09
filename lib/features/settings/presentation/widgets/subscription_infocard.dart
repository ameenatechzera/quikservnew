import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/screens/login_screen.dart';
import 'package:quikservnew/features/settings/presentation/screens/settings_dashboard.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SubscriptionInfoCard extends StatelessWidget {
  const SubscriptionInfoCard({super.key});

  Future<Map<String, String>> _loadData() async {
    final prefs = SharedPreferenceHelper();

    String companyName = await prefs.getCompanyName() ?? '';
    String subCode = await prefs.getSubscriptionCode();
    String expiryDate = await prefs.getExpiryDate();

    // Print values
    print("Company Name: $companyName");
    print("Subscription Code: $subCode");
    print("Expiry Date: $expiryDate");

    st_companyName = companyName;

    return {
      'companyName': companyName,
      'subCode': subCode,
      'expiryDate': expiryDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return FutureBuilder<Map<String, String>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final data = snapshot.data!;
            final companyName = data['companyName'] ?? '';
            final subCode = data['subCode'] ?? '';
            final rawExpiryDate = data['expiryDate'] ?? '';

            // Remove time part
            final formattedExpiryDate = rawExpiryDate.isNotEmpty
                ? rawExpiryDate.split(' ').first
                : '';

            //  Calculate remaining days
            DateTime? expiryDateTime;
            int daysRemaining = 0;

            if (rawExpiryDate.isNotEmpty) {
              expiryDateTime = DateTime.parse(rawExpiryDate);
              daysRemaining = expiryDateTime.difference(DateTime.now()).inDays;
            }

            //  Decide color
            final expiryColor = daysRemaining <= 30 ? Colors.red : Colors.green;

            //  Expiry message
            String expiryMessage = '';
            if (rawExpiryDate.isNotEmpty) {
              // if (daysRemaining < 0) {
              //   expiryMessage = 'Your Subscription Has Expired.';
              // } else {
              expiryMessage =
                  'Your Subscription Will End On $formattedExpiryDate.';
              // }
            }

            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1C1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  /// 🔹 MAIN CONTENT
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
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
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    companyName.isEmpty ? '—' : companyName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.subscriptions,
                                      size: 20,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      subCode,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 🔹 Expiry Message
                      if (expiryMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: expiryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  expiryMessage,
                                  style: TextStyle(
                                    color: expiryColor,
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

                  // CHECK FOR UPDATE BUTTON (Top Right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        print("Check for update clicked");

                        final subscriptionCode = await SharedPreferenceHelper()
                            .getSubscriptionCode();

                        context.read<RegisterCubit>().registerServer(
                          RegisterServerRequest(slno: subscriptionCode),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0B3D3B),
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(Icons.update),
                    ),
                  ),
                ],
              ),
            );
          },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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
              Navigator.pop(dialogContext); // close dialog

              onConfirm();

              // Clear local storage
              await SharedPreferenceHelper().setToken('');
              await SharedPreferenceHelper().setBranchId('');
              await SharedPreferenceHelper().setSubscriptionCode('');

              // Clear cubit safely (no more context usage)
              //  await productCubit.clearProducts();

              if (!parentContext.mounted) return;
              await SharedPreferenceHelper().setLogoutStatus('true');
              Navigator.of(
                parentContext,
              ).push(MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
