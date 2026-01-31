import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';
import 'package:quikservnew/features/accountledger/presentation/screens/account_ledger_creation_screen.dart';
import 'package:quikservnew/features/accountledger/presentation/widgets/accountledger_widgets.dart';

class AccountLedgerListingScreen extends StatelessWidget {
  const AccountLedgerListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch ledger data when screen loads
    context.read<AccountledgerCubit>().fetchAccountLedger();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        title: "Account Ledgers",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: AccountLedgerCreationScreen(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AccountledgerCubit, AccountledgerState>(
        listener: (context, state) {
          if (state is AccountledgerError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is AccountledgerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AccountledgerLoaded) {
            final ledgers = state.accountLedger;
            debugPrint("📦 TOTAL LEDGERS FROM API: ${ledgers.ledgers!.length}");

            if (ledgers.ledgers!.isEmpty) {
              return const Center(child: Text("No Ledgers Available"));
            }
            return ListView.separated(
              itemCount: ledgers.ledgers!.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ledger = ledgers.ledgers![index];
                return AccountLedgerTile(
                  title: ledger.ledgerName!,
                  onEdit: () {
                    debugPrint(
                      "✏️ Edit tapped for ledgerId = ${ledger.ledgerId}",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountLedgerCreationScreen(
                          ledgerId: ledger.ledgerId,
                          existingLedger: ledger,
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    debugPrint(
                      "🟥 Delete tapped for ledgerId = ${ledger.ledgerId}",
                    );
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Ledger"),
                          content: const Text(
                            "Are you sure you want to delete this account ledger?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete == true) {
                      debugPrint("✅ User confirmed delete");
                      context.read<AccountledgerCubit>().deleteAccountLedger(
                        ledger.ledgerId!,
                      );
                    }
                  },
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
