class AccountLedgerParams {
  final String exchangeDate;
  final double exchangeRate;
  final int currencyConversionId;
  final String activeFinancialYearFromDate;
  final String ledgerName;
  final int groupId;
  final bool billBybill;
  final double openingBalance;
  final String crOrDr;
  final String narration;
  final String name;
  final String accountNo;
  final String address;
  final String phoneNo;
  final String faxNo;
  final String email;
  final int creditPeriod;
  final double creditLimit;
  final int pricingLevelId;
  final int currencyId;
  final bool interestOrNot;
  final int branchId;
  final int marketId;
  final String tinNumber;
  final String cstNumber;
  final String panNumber;
  final String extraDate;
  final String extra1;
  final String extra2;
  final int areaId;
  final int ledgerCode;
  final String buildingNo;
  final String additionalNo;
  final String streetName;
  final String postboxNo;
  final String cityName;
  final String country;
  final bool creditLimitStatus;
  final String bankAccName;
  final String bankName;
  final String ibanNo;
  final String district;
  final String streetNameArb;
  final String buildingNoArb;
  final String cityNameArb;
  final String districtArb;
  final String countryArb;
  final String additionalNoArb;
  final String postboxNoArb;
  final String bankBranchName;
  final String bankSwiftCode;
  final String addressArabic;
  final String ledgerType;
  final int routeId;
  final String createdUser;

  const AccountLedgerParams({
    required this.exchangeDate,
    required this.exchangeRate,
    required this.currencyConversionId,
    required this.activeFinancialYearFromDate,
    required this.ledgerName,
    required this.groupId,
    required this.billBybill,
    required this.openingBalance,
    required this.crOrDr,
    required this.narration,
    required this.name,
    required this.accountNo,
    required this.address,
    required this.phoneNo,
    required this.faxNo,
    required this.email,
    required this.creditPeriod,
    required this.creditLimit,
    required this.pricingLevelId,
    required this.currencyId,
    required this.interestOrNot,
    required this.branchId,
    required this.marketId,
    required this.tinNumber,
    required this.cstNumber,
    required this.panNumber,
    required this.extraDate,
    required this.extra1,
    required this.extra2,
    required this.areaId,
    required this.ledgerCode,
    required this.buildingNo,
    required this.additionalNo,
    required this.streetName,
    required this.postboxNo,
    required this.cityName,
    required this.country,
    required this.creditLimitStatus,
    required this.bankAccName,
    required this.bankName,
    required this.ibanNo,
    required this.district,
    required this.streetNameArb,
    required this.buildingNoArb,
    required this.cityNameArb,
    required this.districtArb,
    required this.countryArb,
    required this.additionalNoArb,
    required this.postboxNoArb,
    required this.bankBranchName,
    required this.bankSwiftCode,
    required this.addressArabic,
    required this.ledgerType,
    required this.routeId,
    required this.createdUser,
  });

  Map<String, dynamic> toJson() {
    return {
      "exchangeDate": exchangeDate,
      "exchangeRate": exchangeRate,
      "currencyConversionId": currencyConversionId,
      "activeFinancialYear_fromDate": activeFinancialYearFromDate,
      "ledgerName": ledgerName,
      "groupId": groupId,
      "billBybill": billBybill,
      "openingBalance": openingBalance,
      "crOrDr": crOrDr,
      "narration": narration,
      "name": name,
      "accountNo": accountNo,
      "address": address,
      "phoneNo": phoneNo,
      "faxNo": faxNo,
      "email": email,
      "creditPeriod": creditPeriod,
      "creditLimit": creditLimit,
      "pricingLevelId": pricingLevelId,
      "currencyId": currencyId,
      "interestOrNot": interestOrNot,
      "branchId": branchId,
      "marketId": marketId,
      "tinNumber": tinNumber,
      "cstNumber": cstNumber,
      "panNumber": panNumber,
      "extraDate": extraDate,
      "extra1": extra1,
      "extra2": extra2,
      "areaId": areaId,
      "ledgerCode": ledgerCode,
      "BuildingNo": buildingNo,
      "AdditionalNo": additionalNo,
      "StreetName": streetName,
      "PostboxNo": postboxNo,
      "CityName": cityName,
      "Country": country,
      "creditLimitStatus": creditLimitStatus,
      "bankaccname": bankAccName,
      "bankname": bankName,
      "ibanno": ibanNo,
      "District": district,
      "StreetNameArb": streetNameArb,
      "BuildingNoArb": buildingNoArb,
      "CityNameArb": cityNameArb,
      "DistrictArb": districtArb,
      "CountryArb": countryArb,
      "AdditionalNoArb": additionalNoArb,
      "PostboxNoArb": postboxNoArb,
      "bankBranchName": bankBranchName,
      "bankSwiftCode": bankSwiftCode,
      "AddressArabic": addressArabic,
      "ledgerType": ledgerType,
      "routeId": routeId,
      "CreatedUser": createdUser,
    };
  }
}
