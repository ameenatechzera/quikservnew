import 'package:quikservnew/features/settings/domain/entities/fetch_settings_entity.dart';

class FetchSettingsResponseModel extends FetchSettingsResponse {
  FetchSettingsResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchSettingsDetailsModel>? super.settings,
  });

  factory FetchSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchSettingsResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      settings: json['settings'] != null
          ? List<FetchSettingsDetailsModel>.from(
              json['settings'].map(
                (x) => FetchSettingsDetailsModel.fromJson(x),
              ),
            )
          : [],
    );
  }
}

class FetchSettingsDetailsModel extends FetchSettingsDetails {
  FetchSettingsDetailsModel({
    super.settingsId,
    super.cashLedgerId,
    super.cardLedgerId,
    super.bankLedgerId,
    super.defaultLedger,
    super.autoSync,
    super.manualSync,
    super.syncDuration,
    super.isDirectSale,
    super.isOrderAndSale,
    super.isKOT,
    super.isTableSetup,
    super.isSalesrateEditable,
    super.branchId,
    super.appVersion,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.cashLedgerName,
    super.cardLedgerName,
    super.bankLedgerName,
    super.vatStatus,
    super.vatType,
    super.isSingleCounter,
  });

  factory FetchSettingsDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchSettingsDetailsModel(
      settingsId: json['settings_id'],
      cashLedgerId: json['cash_ledger_id']?.toString(),
      cardLedgerId: json['card_ledger_id']?.toString(),
      bankLedgerId: json['bank_ledger_id']?.toString(),
      defaultLedger: json['default_ledger']?.toString(),
      autoSync: json['auto_sync'],
      manualSync: json['manual_sync'],
      syncDuration: json['sync_duration']?.toString(),
      isDirectSale: json['isDirectSale'],
      isOrderAndSale: json['isOrderAndSale'],
      isKOT: json['isKOT'],
      isTableSetup: json['isTable_setup'],
      isSalesrateEditable: json['isSalesrate_editable'],
      branchId: json['branchId'],
      createdDate: json['CreatedDate'],
      createdUser: json['CreatedUser']?.toString(),
      modifiedDate: json['ModifiedDate'],
      modifiedUser: json['ModifiedUser']?.toString(),
      cashLedgerName: json['cash_ledger_name'],
      cardLedgerName: json['card_ledger_name'],
      bankLedgerName: json['bank_ledger_name'],
      vatStatus: json['vatstatus'],
      vatType: json['vattype'],
      isSingleCounter: json['issinglecounter'],
    );
  }
}
