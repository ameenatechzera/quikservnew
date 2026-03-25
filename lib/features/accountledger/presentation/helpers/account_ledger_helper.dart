import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';

void onSaveAccountLedger({
  required BuildContext context,
  required TextEditingController ledgerNameController,
  required TextEditingController ledgerCodeController,
  required TextEditingController openingBalanceController,
  required int? ledgerId,
}) {
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

  /// API Call
  if (ledgerId == null) {
    context.read<AccountledgerCubit>().saveAccountLedger(params);
  } else {
    context.read<AccountledgerCubit>().updateAccountLedger(ledgerId, params);
  }
}
