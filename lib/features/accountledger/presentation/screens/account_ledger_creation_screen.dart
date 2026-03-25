import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountledger/domain/entities/fetch_accountledger_entity.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';
import 'package:quikservnew/features/accountledger/presentation/helpers/account_ledger_helper.dart';
import 'package:quikservnew/features/accountledger/presentation/widgets/accountledger_widgets.dart';

class AccountLedgerCreationScreen extends StatelessWidget {
  AccountLedgerCreationScreen({super.key, this.ledgerId, this.existingLedger}) {
    /// 🔹 Prefill for UPDATE
    if (existingLedger != null) {
      ledgerNameController.text = existingLedger!.ledgerName!;
      ledgerCodeController.text = existingLedger!.ledgerCode.toString();
      openingBalanceController.text = existingLedger!.openingBalance.toString();
      selectedGroupId.value = existingLedger!.groupId;
    }
  }

  /// null = ADD | not null = UPDATE
  final int? ledgerId;
  final FetchAccountLedgerDetailsEntity? existingLedger;

  final TextEditingController ledgerNameController = TextEditingController();
  final TextEditingController ledgerCodeController = TextEditingController();
  final TextEditingController openingBalanceController =
      TextEditingController();

  final ValueNotifier<int?> selectedGroupId = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FA),
      appBar: CommonAppBar(
        title: ledgerId == null
            ? "Add Account Ledger"
            : "Update Account Ledger",
      ),
      body: BlocListener<AccountledgerCubit, AccountledgerState>(
        listener: (context, state) {
          if (state is AccountledgerError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
          if (state is AccountledgerLoaded) {
            showAnimatedToast(
              context,
              message: "Ledger saved successfully",
              isSuccess: true,
            );
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textField(
                  label: "Ledger Name",
                  controller: ledgerNameController,
                ),
                const SizedBox(height: 20),

                textField(
                  label: "Ledger Code",
                  controller: ledgerCodeController,
                ),
                const SizedBox(height: 20),

                /// 👇 ACCOUNT GROUP DROPDOWN FROM API
                // accountGroupDropdown(),
                // dropdownField(),
                // const SizedBox(height: 20),
                textField(
                  label: "Opening Balance",
                  keyboardType: TextInputType.number,
                  controller: openingBalanceController,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => onSaveAccountLedger(
                      context: context,
                      ledgerNameController: ledgerNameController,
                      ledgerCodeController: ledgerCodeController,
                      openingBalanceController: openingBalanceController,
                      ledgerId: ledgerId,
                    ),
                    child: Text(
                      ledgerId == null
                          ? "Add Account Ledger"
                          : "Update Account Ledger",
                      style: TextStyle(
                        fontSize: 16,

                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
