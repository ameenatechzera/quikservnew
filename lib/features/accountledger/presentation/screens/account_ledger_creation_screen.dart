import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';
import 'package:quikservnew/features/accountledger/domain/entities/fetch_accountledger_entity.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';
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
    //context.read<AccountGroupCubit>().fetchAccountGroups();

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
                    onPressed: () => _onSavePressed(context),
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

  /// 🔹 SAVE ACTION
  void _onSavePressed(BuildContext context) {
    if (ledgerNameController.text.isEmpty ||
        ledgerCodeController.text.isEmpty ||
        openingBalanceController.text.isEmpty) {
      showAnimatedToast(
        context,
        message: "Please fill all required fields",
        isSuccess: false,
      );
      return;
    }
    final params = AccountLedgerParams(
      exchangeDate: '',
      exchangeRate: 0,
      currencyConversionId: 0,
      activeFinancialYearFromDate: '',
      ledgerName: ledgerNameController.text,
      // groupId: selectedGroupId.value!,
      groupId: 12,
      billBybill: false,
      openingBalance: double.parse(openingBalanceController.text),
      crOrDr: '',
      narration: '',
      name: '',
      accountNo: '',
      address: '',
      phoneNo: '',
      faxNo: '',
      email: '',
      creditPeriod: 0,
      creditLimit: 0,
      pricingLevelId: 1,
      currencyId: 0,
      interestOrNot: false,
      branchId: 1,
      marketId: 0,
      tinNumber: '',
      cstNumber: '',
      panNumber: '',
      extraDate: '',
      extra1: '',
      extra2: '',
      areaId: 0,
      ledgerCode: int.parse(ledgerCodeController.text),
      buildingNo: '',
      additionalNo: '',
      streetName: '',
      postboxNo: '',
      cityName: '',
      country: '',
      creditLimitStatus: true,
      bankAccName: '',
      bankName: '',
      ibanNo: '',
      district: '',
      streetNameArb: '',
      buildingNoArb: '',
      cityNameArb: '',
      districtArb: '',
      countryArb: '',
      additionalNoArb: '',
      postboxNoArb: '',
      bankBranchName: '',
      bankSwiftCode: '',
      addressArabic: '',
      ledgerType: '',
      routeId: 0,
      createdUser: '',
    );

    if (ledgerId == null) {
      context.read<AccountledgerCubit>().saveAccountLedger(params);
    } else {
      context.read<AccountledgerCubit>().updateAccountLedger(ledgerId!, params);
    }
  }

  // Widget accountGroupDropdown() {
  //   return BlocBuilder<AccountGroupCubit, AccountGroupState>(
  //     builder: (context, state) {
  //       if (state is AccountGroupInitial) {
  //         return const SizedBox.shrink();
  //       }
  //
  //       // if (state is Account) {
  //       //   return const Padding(
  //       //     padding: EdgeInsets.symmetric(vertical: 12),
  //       //     child: LinearProgressIndicator(),
  //       //   );
  //       // }
  //
  //       if (state is AccountGroupsError) {
  //         return Text(state.error, style: const TextStyle(color: Colors.red));
  //       }
  //
  //       // if (state is AccountGroupsLoaded) {
  //       //   final groups = state.account_groups;
  //       //
  //       //   return ValueListenableBuilder<int?>(
  //       //     valueListenable: selectedGroupId,
  //       //     builder: (context, value, _) {
  //       //       return DropdownButtonFormField<int>(
  //       //         decoration: const InputDecoration(
  //       //           labelText: "Select Account Group",
  //       //           border: UnderlineInputBorder(),
  //       //         ),
  //       //         value: value,
  //       //         items: groups.map((group) {
  //       //           return DropdownMenuItem<int>(
  //       //             value: group.groupId,
  //       //             child: Text(group.accountGroupName),
  //       //           );
  //       //         }).toList(),
  //       //         onChanged: (value) {
  //       //           selectedGroupId.value = value;
  //       //           // store selected groupId
  //       //           print("Selected groupId: $value");
  //       //         },
  //       //       );
  //       //     },
  //       //   );
  //       // }
  //
  //       return const SizedBox.shrink();
  //     },
  //   );
  // }
}
