import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/settings/presentation/widgets/accountsettings_widget.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class AccountSettingsScreen extends StatelessWidget {
  AccountSettingsScreen({super.key});
  // 🔹 Controllers to hold selected ledger names
  final TextEditingController cashLedgerController = TextEditingController();
  final TextEditingController cardLedgerController = TextEditingController();
  final TextEditingController bankLedgerController = TextEditingController();
  // 🔹 Store selected ledger IDs
  int? selectedCashLedgerId;
  int? selectedCardLedgerId;
  int? selectedBankLedgerId;
  bool isUpdate = false; // 👈 flag to decide Save / Update

  Future<void> _loadSavedLedgers() async {
    final helper = SharedPreferenceHelper();
    final data = await helper.getLedgers();

    selectedCashLedgerId = data['cashLedgerId'];
    selectedCardLedgerId = data['cardLedgerId'];
    selectedBankLedgerId = data['bankLedgerId'];

    cashLedgerController.text = data['cashLedgerName'] ?? '';
    cardLedgerController.text = data['cardLedgerName'] ?? '';
    bankLedgerController.text = data['bankLedgerName'] ?? '';

    // 👇 If all ledgers exist, switch to UPDATE mode
    if (selectedCashLedgerId != null &&
        selectedCardLedgerId != null &&
        selectedBankLedgerId != null) {
      isUpdate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadSavedLedgers(),
      builder: (context, snapshot) {
        // While loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFFDF3F6),
          appBar: const CommonAppBar(title: "Account Settings"),
          body: BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is SaveAccountSettingsSuccess) {
                showAnimatedToast(
                  context,
                  message: "Account settings saved successfully",
                  isSuccess: true,
                );
              } else if (state is SaveAccountSettingsError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InputField(
                    label: "Cash Ledger *",
                    controller: cashLedgerController,
                    onTap: () async {
                      final selectedLedger = await showBankLedgerBottomSheet(
                        context,
                      );
                      if (selectedLedger != null) {
                        cashLedgerController.text =
                            selectedLedger.bankAccName ??
                            selectedLedger.ledgerName ??
                            '';
                        selectedCashLedgerId = selectedLedger.ledgerId;
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  InputField(
                    label: "Card Ledger *",
                    controller: cardLedgerController,
                    onTap: () async {
                      final selectedLedger = await showBankLedgerBottomSheet(
                        context,
                      );
                      if (selectedLedger != null) {
                        cardLedgerController.text =
                            selectedLedger.bankAccName ??
                            selectedLedger.ledgerName ??
                            '';
                        selectedCardLedgerId = selectedLedger.ledgerId;
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  InputField(
                    label: "Bank Ledger *",
                    controller: bankLedgerController,
                    onTap: () async {
                      final selectedLedger = await showBankLedgerBottomSheet(
                        context,
                      );
                      if (selectedLedger != null) {
                        bankLedgerController.text =
                            selectedLedger.bankAccName ??
                            selectedLedger.ledgerName ??
                            '';
                        selectedBankLedgerId = selectedLedger.ledgerId;
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        if (selectedCashLedgerId == null ||
                            selectedCardLedgerId == null ||
                            selectedBankLedgerId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select all ledgers"),
                            ),
                          );
                          return;
                        }

                        final params = AccountSettingsParams(
                          cashLedgerId: selectedCashLedgerId!,
                          cardLedgerId: selectedCardLedgerId!,
                          bankLedgerId: selectedBankLedgerId!,
                        );

                        context.read<SettingsCubit>().saveAccountSettings(
                          params,
                        );
                        // Also save in SharedPreferences
                        final helper = SharedPreferenceHelper();
                        await helper.saveLedgers(
                          cashLedgerId: selectedCashLedgerId!,
                          cashLedgerName: cashLedgerController.text,
                          cardLedgerId: selectedCardLedgerId!,
                          cardLedgerName: cardLedgerController.text,
                          bankLedgerId: selectedBankLedgerId!,
                          bankLedgerName: bankLedgerController.text,
                        );
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
