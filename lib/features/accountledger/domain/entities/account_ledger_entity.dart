import 'package:equatable/equatable.dart';

class AccountLedgerResponse extends Equatable {
  AccountLedgerResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<Datum> data;
  static const String dataKey = "data";


  AccountLedgerResponse copyWith({
    int? status,
    bool? error,
    String? message,
    List<Datum>? data,
  }) {
    return AccountLedgerResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory AccountLedgerResponse.fromJson(Map<String, dynamic> json){
    return AccountLedgerResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, data, ];
}

class Datum extends Equatable {
  Datum({
    required this.ledgerId,
    required this.ledgerName,
    required this.groupId,
    required this.billBybill,
    required this.openingBalance,
    required this.crOrDr,
    required this.narration,
    required this.nameArb,
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
    required this.datumDefault,
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
    required this.bankaccname,
    required this.bankname,
    required this.ibanno,
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
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
  });

  final int ledgerId;
  static const String ledgerIdKey = "ledgerId";

  final String ledgerName;
  static const String ledgerNameKey = "ledgerName";

  final int groupId;
  static const String groupIdKey = "groupId";

  final dynamic billBybill;
  static const String billBybillKey = "billBybill";

  final String openingBalance;
  static const String openingBalanceKey = "openingBalance";

  final String crOrDr;
  static const String crOrDrKey = "crOrDr";

  final String narration;
  static const String narrationKey = "narration";

  final dynamic nameArb;
  static const String nameArbKey = "nameArb";

  final String accountNo;
  static const String accountNoKey = "accountNo";

  final dynamic address;
  static const String addressKey = "address";

  final dynamic phoneNo;
  static const String phoneNoKey = "phoneNo";

  final dynamic faxNo;
  static const String faxNoKey = "faxNo";

  final dynamic email;
  static const String emailKey = "email";

  final dynamic creditPeriod;
  static const String creditPeriodKey = "creditPeriod";

  final dynamic creditLimit;
  static const String creditLimitKey = "creditLimit";

  final dynamic pricingLevelId;
  static const String pricingLevelIdKey = "pricingLevelId";

  final dynamic currencyId;
  static const String currencyIdKey = "currencyId";

  final dynamic interestOrNot;
  static const String interestOrNotKey = "interestOrNot";

  final int branchId;
  static const String branchIdKey = "branchId";

  final dynamic marketId;
  static const String marketIdKey = "marketId";

  final bool datumDefault;
  static const String datumDefaultKey = "default";

  final dynamic tinNumber;
  static const String tinNumberKey = "tinNumber";

  final dynamic cstNumber;
  static const String cstNumberKey = "cstNumber";

  final dynamic panNumber;
  static const String panNumberKey = "panNumber";

  final DateTime? extraDate;
  static const String extraDateKey = "extraDate";

  final dynamic extra1;
  static const String extra1Key = "extra1";

  final dynamic extra2;
  static const String extra2Key = "extra2";

  final dynamic areaId;
  static const String areaIdKey = "areaId";

  final String ledgerCode;
  static const String ledgerCodeKey = "ledgerCode";

  final dynamic buildingNo;
  static const String buildingNoKey = "BuildingNo";

  final dynamic additionalNo;
  static const String additionalNoKey = "AdditionalNo";

  final dynamic streetName;
  static const String streetNameKey = "StreetName";

  final dynamic postboxNo;
  static const String postboxNoKey = "PostboxNo";

  final dynamic cityName;
  static const String cityNameKey = "CityName";

  final dynamic country;
  static const String countryKey = "Country";

  final dynamic creditLimitStatus;
  static const String creditLimitStatusKey = "creditLimitStatus";

  final String bankaccname;
  static const String bankaccnameKey = "bankaccname";

  final String bankname;
  static const String banknameKey = "bankname";

  final String ibanno;
  static const String ibannoKey = "ibanno";

  final dynamic district;
  static const String districtKey = "District";

  final dynamic streetNameArb;
  static const String streetNameArbKey = "StreetNameArb";

  final dynamic buildingNoArb;
  static const String buildingNoArbKey = "BuildingNoArb";

  final dynamic cityNameArb;
  static const String cityNameArbKey = "CityNameArb";

  final dynamic districtArb;
  static const String districtArbKey = "DistrictArb";

  final dynamic countryArb;
  static const String countryArbKey = "CountryArb";

  final dynamic additionalNoArb;
  static const String additionalNoArbKey = "AdditionalNoArb";

  final dynamic postboxNoArb;
  static const String postboxNoArbKey = "PostboxNoArb";

  final String bankBranchName;
  static const String bankBranchNameKey = "bankBranchName";

  final String bankSwiftCode;
  static const String bankSwiftCodeKey = "bankSwiftCode";

  final dynamic addressArabic;
  static const String addressArabicKey = "AddressArabic";

  final dynamic ledgerType;
  static const String ledgerTypeKey = "ledgerType";

  final dynamic routeId;
  static const String routeIdKey = "routeId";

  final DateTime? createdDate;
  static const String createdDateKey = "CreatedDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";


  Datum copyWith({
    int? ledgerId,
    String? ledgerName,
    int? groupId,
    dynamic? billBybill,
    String? openingBalance,
    String? crOrDr,
    String? narration,
    dynamic? nameArb,
    String? accountNo,
    dynamic? address,
    dynamic? phoneNo,
    dynamic? faxNo,
    dynamic? email,
    dynamic? creditPeriod,
    dynamic? creditLimit,
    dynamic? pricingLevelId,
    dynamic? currencyId,
    dynamic? interestOrNot,
    int? branchId,
    dynamic? marketId,
    bool? datumDefault,
    dynamic? tinNumber,
    dynamic? cstNumber,
    dynamic? panNumber,
    DateTime? extraDate,
    dynamic? extra1,
    dynamic? extra2,
    dynamic? areaId,
    String? ledgerCode,
    dynamic? buildingNo,
    dynamic? additionalNo,
    dynamic? streetName,
    dynamic? postboxNo,
    dynamic? cityName,
    dynamic? country,
    dynamic? creditLimitStatus,
    String? bankaccname,
    String? bankname,
    String? ibanno,
    dynamic? district,
    dynamic? streetNameArb,
    dynamic? buildingNoArb,
    dynamic? cityNameArb,
    dynamic? districtArb,
    dynamic? countryArb,
    dynamic? additionalNoArb,
    dynamic? postboxNoArb,
    String? bankBranchName,
    String? bankSwiftCode,
    dynamic? addressArabic,
    dynamic? ledgerType,
    dynamic? routeId,
    DateTime? createdDate,
    String? createdUser,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
  }) {
    return Datum(
      ledgerId: ledgerId ?? this.ledgerId,
      ledgerName: ledgerName ?? this.ledgerName,
      groupId: groupId ?? this.groupId,
      billBybill: billBybill ?? this.billBybill,
      openingBalance: openingBalance ?? this.openingBalance,
      crOrDr: crOrDr ?? this.crOrDr,
      narration: narration ?? this.narration,
      nameArb: nameArb ?? this.nameArb,
      accountNo: accountNo ?? this.accountNo,
      address: address ?? this.address,
      phoneNo: phoneNo ?? this.phoneNo,
      faxNo: faxNo ?? this.faxNo,
      email: email ?? this.email,
      creditPeriod: creditPeriod ?? this.creditPeriod,
      creditLimit: creditLimit ?? this.creditLimit,
      pricingLevelId: pricingLevelId ?? this.pricingLevelId,
      currencyId: currencyId ?? this.currencyId,
      interestOrNot: interestOrNot ?? this.interestOrNot,
      branchId: branchId ?? this.branchId,
      marketId: marketId ?? this.marketId,
      datumDefault: datumDefault ?? this.datumDefault,
      tinNumber: tinNumber ?? this.tinNumber,
      cstNumber: cstNumber ?? this.cstNumber,
      panNumber: panNumber ?? this.panNumber,
      extraDate: extraDate ?? this.extraDate,
      extra1: extra1 ?? this.extra1,
      extra2: extra2 ?? this.extra2,
      areaId: areaId ?? this.areaId,
      ledgerCode: ledgerCode ?? this.ledgerCode,
      buildingNo: buildingNo ?? this.buildingNo,
      additionalNo: additionalNo ?? this.additionalNo,
      streetName: streetName ?? this.streetName,
      postboxNo: postboxNo ?? this.postboxNo,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      creditLimitStatus: creditLimitStatus ?? this.creditLimitStatus,
      bankaccname: bankaccname ?? this.bankaccname,
      bankname: bankname ?? this.bankname,
      ibanno: ibanno ?? this.ibanno,
      district: district ?? this.district,
      streetNameArb: streetNameArb ?? this.streetNameArb,
      buildingNoArb: buildingNoArb ?? this.buildingNoArb,
      cityNameArb: cityNameArb ?? this.cityNameArb,
      districtArb: districtArb ?? this.districtArb,
      countryArb: countryArb ?? this.countryArb,
      additionalNoArb: additionalNoArb ?? this.additionalNoArb,
      postboxNoArb: postboxNoArb ?? this.postboxNoArb,
      bankBranchName: bankBranchName ?? this.bankBranchName,
      bankSwiftCode: bankSwiftCode ?? this.bankSwiftCode,
      addressArabic: addressArabic ?? this.addressArabic,
      ledgerType: ledgerType ?? this.ledgerType,
      routeId: routeId ?? this.routeId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      ledgerId: json["ledgerId"] ?? 0,
      ledgerName: json["ledgerName"] ?? "",
      groupId: json["groupId"] ?? 0,
      billBybill: json["billBybill"],
      openingBalance: json["openingBalance"] ?? "",
      crOrDr: json["crOrDr"] ?? "",
      narration: json["narration"] ?? "",
      nameArb: json["nameArb"],
      accountNo: json["accountNo"] ?? "",
      address: json["address"],
      phoneNo: json["phoneNo"],
      faxNo: json["faxNo"],
      email: json["email"],
      creditPeriod: json["creditPeriod"],
      creditLimit: json["creditLimit"],
      pricingLevelId: json["pricingLevelId"],
      currencyId: json["currencyId"],
      interestOrNot: json["interestOrNot"],
      branchId: json["branchId"] ?? 0,
      marketId: json["marketId"],
      datumDefault: json["default"] ?? false,
      tinNumber: json["tinNumber"],
      cstNumber: json["cstNumber"],
      panNumber: json["panNumber"],
      extraDate: DateTime.tryParse(json["extraDate"] ?? ""),
      extra1: json["extra1"],
      extra2: json["extra2"],
      areaId: json["areaId"],
      ledgerCode: json["ledgerCode"] ?? "",
      buildingNo: json["BuildingNo"],
      additionalNo: json["AdditionalNo"],
      streetName: json["StreetName"],
      postboxNo: json["PostboxNo"],
      cityName: json["CityName"],
      country: json["Country"],
      creditLimitStatus: json["creditLimitStatus"],
      bankaccname: json["bankaccname"] ?? "",
      bankname: json["bankname"] ?? "",
      ibanno: json["ibanno"] ?? "",
      district: json["District"],
      streetNameArb: json["StreetNameArb"],
      buildingNoArb: json["BuildingNoArb"],
      cityNameArb: json["CityNameArb"],
      districtArb: json["DistrictArb"],
      countryArb: json["CountryArb"],
      additionalNoArb: json["AdditionalNoArb"],
      postboxNoArb: json["PostboxNoArb"],
      bankBranchName: json["bankBranchName"] ?? "",
      bankSwiftCode: json["bankSwiftCode"] ?? "",
      addressArabic: json["AddressArabic"],
      ledgerType: json["ledgerType"],
      routeId: json["routeId"],
      createdDate: DateTime.tryParse(json["CreatedDate"] ?? ""),
      createdUser: json["CreatedUser"] ?? "",
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ledgerId": ledgerId,
    "ledgerName": ledgerName,
    "groupId": groupId,
    "billBybill": billBybill,
    "openingBalance": openingBalance,
    "crOrDr": crOrDr,
    "narration": narration,
    "nameArb": nameArb,
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
    "default": datumDefault,
    "tinNumber": tinNumber,
    "cstNumber": cstNumber,
    "panNumber": panNumber,
    "extraDate": extraDate?.toIso8601String(),
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
    "bankaccname": bankaccname,
    "bankname": bankname,
    "ibanno": ibanno,
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
    "CreatedDate": createdDate?.toIso8601String(),
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
  };

  @override
  String toString(){
    return "$ledgerId, $ledgerName, $groupId, $billBybill, $openingBalance, $crOrDr, $narration, $nameArb, $accountNo, $address, $phoneNo, $faxNo, $email, $creditPeriod, $creditLimit, $pricingLevelId, $currencyId, $interestOrNot, $branchId, $marketId, $datumDefault, $tinNumber, $cstNumber, $panNumber, $extraDate, $extra1, $extra2, $areaId, $ledgerCode, $buildingNo, $additionalNo, $streetName, $postboxNo, $cityName, $country, $creditLimitStatus, $bankaccname, $bankname, $ibanno, $district, $streetNameArb, $buildingNoArb, $cityNameArb, $districtArb, $countryArb, $additionalNoArb, $postboxNoArb, $bankBranchName, $bankSwiftCode, $addressArabic, $ledgerType, $routeId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, ";
  }

  @override
  List<Object?> get props => [
    ledgerId, ledgerName, groupId, billBybill, openingBalance, crOrDr, narration, nameArb, accountNo, address, phoneNo, faxNo, email, creditPeriod, creditLimit, pricingLevelId, currencyId, interestOrNot, branchId, marketId, datumDefault, tinNumber, cstNumber, panNumber, extraDate, extra1, extra2, areaId, ledgerCode, buildingNo, additionalNo, streetName, postboxNo, cityName, country, creditLimitStatus, bankaccname, bankname, ibanno, district, streetNameArb, buildingNoArb, cityNameArb, districtArb, countryArb, additionalNoArb, postboxNoArb, bankBranchName, bankSwiftCode, addressArabic, ledgerType, routeId, createdDate, createdUser, modifiedDate, modifiedUser, ];
}
