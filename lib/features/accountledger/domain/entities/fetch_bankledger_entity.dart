class FetchBankAccountLedgerResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchBankAccountLedgerDetailsEntity>? data;

  FetchBankAccountLedgerResponseEntity({
    this.status,
    this.error,
    this.message,
    this.data,
  });
}

class FetchBankAccountLedgerDetailsEntity {
  final int? ledgerId;
  final String? ledgerName;
  final int? groupId;
  final bool? billByBill;
  final String? openingBalance;
  final String? crOrDr;
  final String? narration;
  final String? nameArb;
  final String? accountNo;
  final String? address;
  final String? phoneNo;
  final String? faxNo;
  final String? email;
  final int? creditPeriod;
  final String? creditLimit;
  final int? pricingLevelId;
  final int? currencyId;
  final bool? interestOrNot;
  final int? branchId;
  final int? marketId;
  final bool? defaultValue;
  final String? tinNumber;
  final String? cstNumber;
  final String? panNumber;
  final String? extraDate;
  final String? extra1;
  final String? extra2;
  final int? areaId;
  final String? ledgerCode;
  final String? buildingNo;
  final String? additionalNo;
  final String? streetName;
  final String? postboxNo;
  final String? cityName;
  final String? country;
  final String? creditLimitStatus;
  final String? bankAccName;
  final String? bankName;
  final String? ibanNo;
  final String? district;
  final String? streetNameArb;
  final String? buildingNoArb;
  final String? cityNameArb;
  final String? districtArb;
  final String? countryArb;
  final String? additionalNoArb;
  final String? postboxNoArb;
  final String? bankBranchName;
  final String? bankSwiftCode;
  final String? addressArabic;
  final String? ledgerType;
  final int? routeId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;

  FetchBankAccountLedgerDetailsEntity({
    this.ledgerId,
    this.ledgerName,
    this.groupId,
    this.billByBill,
    this.openingBalance,
    this.crOrDr,
    this.narration,
    this.nameArb,
    this.accountNo,
    this.address,
    this.phoneNo,
    this.faxNo,
    this.email,
    this.creditPeriod,
    this.creditLimit,
    this.pricingLevelId,
    this.currencyId,
    this.interestOrNot,
    this.branchId,
    this.marketId,
    this.defaultValue,
    this.tinNumber,
    this.cstNumber,
    this.panNumber,
    this.extraDate,
    this.extra1,
    this.extra2,
    this.areaId,
    this.ledgerCode,
    this.buildingNo,
    this.additionalNo,
    this.streetName,
    this.postboxNo,
    this.cityName,
    this.country,
    this.creditLimitStatus,
    this.bankAccName,
    this.bankName,
    this.ibanNo,
    this.district,
    this.streetNameArb,
    this.buildingNoArb,
    this.cityNameArb,
    this.districtArb,
    this.countryArb,
    this.additionalNoArb,
    this.postboxNoArb,
    this.bankBranchName,
    this.bankSwiftCode,
    this.addressArabic,
    this.ledgerType,
    this.routeId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
  });
}
