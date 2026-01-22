class FetchSettingsResponse {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchSettingsDetails>? settings;

  FetchSettingsResponse({this.status, this.error, this.message, this.settings});
}

class FetchSettingsDetails {
  final int? settingsId;
  final String? cashLedgerId;
  final String? cardLedgerId;
  final String? bankLedgerId;
  final String? defaultLedger;
  final int? autoSync;
  final int? manualSync;
  final String? syncDuration;
  final int? isDirectSale;
  final int? isOrderAndSale;
  final int? isKOT;
  final int? isTableSetup;
  final int? isSalesrateEditable;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final String? cashLedgerName;
  final String? cardLedgerName;
  final String? bankLedgerName;
  final bool? vatStatus;
  final String? vatType;
  final bool? isSingleCounter;

  FetchSettingsDetails({
    this.settingsId,
    this.cashLedgerId,
    this.cardLedgerId,
    this.bankLedgerId,
    this.defaultLedger,
    this.autoSync,
    this.manualSync,
    this.syncDuration,
    this.isDirectSale,
    this.isOrderAndSale,
    this.isKOT,
    this.isTableSetup,
    this.isSalesrateEditable,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.cashLedgerName,
    this.cardLedgerName,
    this.bankLedgerName,
    this.vatStatus,
    this.vatType,
    this.isSingleCounter,
  });
}
