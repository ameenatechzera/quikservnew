import 'package:equatable/equatable.dart';

class PaymentVoucherRequest extends Equatable {
  PaymentVoucherRequest({
    required this.branchId,
    required this.voucherType,
    required this.yearId,
    required this.date,
    required this.ledgerId,
    required this.narration,
    required this.totalAmount,
    required this.costCentreId,
    required this.referenceNo,
    required this.referenceDate,
    required this.postedStatus,
    required this.postedBy,
    required this.postedDate,
    required this.exchangeRate,
    required this.exchangeDate,
    required this.createdUser,
    required this.paymentDetails,
    required this.partyDetails,
  });

  final int branchId;
  static const String branchIdKey = "branchId";

  final String voucherType;
  static const String voucherTypeKey = "voucherType";

  final int yearId;
  static const String yearIdKey = "yearId";

  final String? date;
  static const String dateKey = "date";

  final int ledgerId;
  static const String ledgerIdKey = "ledgerId";

  final String narration;
  static const String narrationKey = "narration";

  final int totalAmount;
  static const String totalAmountKey = "totalAmount";

  final int costCentreId;
  static const String costCentreIdKey = "costCentreId";

  final String referenceNo;
  static const String referenceNoKey = "ReferenceNo";

  final String? referenceDate;
  static const String referenceDateKey = "ReferenceDate";

  final int postedStatus;
  static const String postedStatusKey = "postedStatus";

  final String postedBy;
  static const String postedByKey = "postedBy";

  final String? postedDate;
  static const String postedDateKey = "postedDate";

  final int exchangeRate;
  static const String exchangeRateKey = "exchangeRate";

  final String? exchangeDate;
  static const String exchangeDateKey = "exchangeDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final List<PaymentDetail> paymentDetails;
  static const String paymentDetailsKey = "paymentDetails";

  final List<PartyDetail> partyDetails;
  static const String partyDetailsKey = "partyDetails";


  PaymentVoucherRequest copyWith({
    int? branchId,
    String? voucherType,
    int? yearId,
    String? date,
    int? ledgerId,
    String? narration,
    int? totalAmount,
    int? costCentreId,
    String? referenceNo,
    String? referenceDate,
    int? postedStatus,
    String? postedBy,
    String? postedDate,
    int? exchangeRate,
    String? exchangeDate,
    String? createdUser,
    List<PaymentDetail>? paymentDetails,
    List<PartyDetail>? partyDetails,
  }) {
    return PaymentVoucherRequest(
      branchId: branchId ?? this.branchId,
      voucherType: voucherType ?? this.voucherType,
      yearId: yearId ?? this.yearId,
      date: date ?? this.date,
      ledgerId: ledgerId ?? this.ledgerId,
      narration: narration ?? this.narration,
      totalAmount: totalAmount ?? this.totalAmount,
      costCentreId: costCentreId ?? this.costCentreId,
      referenceNo: referenceNo ?? this.referenceNo,
      referenceDate: referenceDate ?? this.referenceDate,
      postedStatus: postedStatus ?? this.postedStatus,
      postedBy: postedBy ?? this.postedBy,
      postedDate: postedDate ?? this.postedDate,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      exchangeDate: exchangeDate ?? this.exchangeDate,
      createdUser: createdUser ?? this.createdUser,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      partyDetails: partyDetails ?? this.partyDetails,
    );
  }

  factory PaymentVoucherRequest.fromJson(Map<String, dynamic> json){
    return PaymentVoucherRequest(
      branchId: json["branchId"] ?? 0,
      voucherType: json["voucherType"] ?? "",
      yearId: json["yearId"] ?? 0,
      date: json["date"] ?? "",
      ledgerId: json["ledgerId"] ?? 0,
      narration: json["narration"] ?? "",
      totalAmount: json["totalAmount"] ?? 0,
      costCentreId: json["costCentreId"] ?? 0,
      referenceNo: json["ReferenceNo"] ?? "",
      referenceDate: json["ReferenceDate"] ?? "",
      postedStatus: json["postedStatus"] ?? 0,
      postedBy: json["postedBy"] ?? "",
      postedDate: json["postedDate"] ?? "",
      exchangeRate: json["exchangeRate"] ?? 0,
      exchangeDate: json["exchangeDate"] ?? "",
      createdUser: json["CreatedUser"] ?? "",
      paymentDetails: json["paymentDetails"] == null ? [] : List<PaymentDetail>.from(json["paymentDetails"]!.map((x) => PaymentDetail.fromJson(x))),
      partyDetails: json["partyDetails"] == null ? [] : List<PartyDetail>.from(json["partyDetails"]!.map((x) => PartyDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "branchId": branchId,
    "voucherType": voucherType,
    "yearId": yearId,
    "date": date,
    "ledgerId": ledgerId,
    "narration": narration,
    "totalAmount": totalAmount,
    "costCentreId": costCentreId,
    "ReferenceNo": referenceNo,
    "ReferenceDate": referenceDate,
    "postedStatus": postedStatus,
    "postedBy": postedBy,
    "postedDate": postedDate,
    "exchangeRate": exchangeRate,
    "exchangeDate": exchangeDate,
    "CreatedUser": createdUser,
    "paymentDetails": paymentDetails.map((x) => x?.toJson()).toList(),
    "partyDetails": partyDetails.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$branchId, $voucherType, $yearId, $date, $ledgerId, $narration, $totalAmount, $costCentreId, $referenceNo, $referenceDate, $postedStatus, $postedBy, $postedDate, $exchangeRate, $exchangeDate, $createdUser, $paymentDetails, $partyDetails, ";
  }

  @override
  List<Object?> get props => [
    branchId, voucherType, yearId, date, ledgerId, narration, totalAmount, costCentreId, referenceNo, referenceDate, postedStatus, postedBy, postedDate, exchangeRate, exchangeDate, createdUser, paymentDetails, partyDetails, ];
}

class PartyDetail extends Equatable {
  PartyDetail({
    required this.date,
    required this.againstVoucherType,
    required this.againstvoucherNo,
    required this.referenceType,
    required this.amount,
    required this.creditPeriod,
    required this.currencyConversionId,
    required this.referenceNo,
    required this.billAmount,
  });

  final String? date;
  static const String dateKey = "date";

  final String againstVoucherType;
  static const String againstVoucherTypeKey = "againstVoucherType";

  final String againstvoucherNo;
  static const String againstvoucherNoKey = "againstvoucherNo";

  final String referenceType;
  static const String referenceTypeKey = "referenceType";

  final int amount;
  static const String amountKey = "Amount";

  final int creditPeriod;
  static const String creditPeriodKey = "creditPeriod";

  final int currencyConversionId;
  static const String currencyConversionIdKey = "currencyConversionId";

  final String referenceNo;
  static const String referenceNoKey = "referenceNo";

  final int billAmount;
  static const String billAmountKey = "BillAmount";


  PartyDetail copyWith({
    String? date,
    String? againstVoucherType,
    String? againstvoucherNo,
    String? referenceType,
    int? amount,
    int? creditPeriod,
    int? currencyConversionId,
    String? referenceNo,
    int? billAmount,
  }) {
    return PartyDetail(
      date: date ?? this.date,
      againstVoucherType: againstVoucherType ?? this.againstVoucherType,
      againstvoucherNo: againstvoucherNo ?? this.againstvoucherNo,
      referenceType: referenceType ?? this.referenceType,
      amount: amount ?? this.amount,
      creditPeriod: creditPeriod ?? this.creditPeriod,
      currencyConversionId: currencyConversionId ?? this.currencyConversionId,
      referenceNo: referenceNo ?? this.referenceNo,
      billAmount: billAmount ?? this.billAmount,
    );
  }

  factory PartyDetail.fromJson(Map<String, dynamic> json){
    return PartyDetail(
      date: json["date"] ?? "",
      againstVoucherType: json["againstVoucherType"] ?? "",
      againstvoucherNo: json["againstvoucherNo"] ?? "",
      referenceType: json["referenceType"] ?? "",
      amount: json["Amount"] ?? 0,
      creditPeriod: json["creditPeriod"] ?? 0,
      currencyConversionId: json["currencyConversionId"] ?? 0,
      referenceNo: json["referenceNo"] ?? "",
      billAmount: json["BillAmount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "againstVoucherType": againstVoucherType,
    "againstvoucherNo": againstvoucherNo,
    "referenceType": referenceType,
    "Amount": amount,
    "creditPeriod": creditPeriod,
    "currencyConversionId": currencyConversionId,
    "referenceNo": referenceNo,
    "BillAmount": billAmount,
  };

  @override
  String toString(){
    return "$date, $againstVoucherType, $againstvoucherNo, $referenceType, $amount, $creditPeriod, $currencyConversionId, $referenceNo, $billAmount, ";
  }

  @override
  List<Object?> get props => [
    date, againstVoucherType, againstvoucherNo, referenceType, amount, creditPeriod, currencyConversionId, referenceNo, billAmount, ];
}

class PaymentDetail extends Equatable {
  PaymentDetail({
    required this.ledgerId,
    required this.amount,
    required this.currencyConversionId,
    required this.chequeNo,
    required this.chequeDate,
    required this.lineIndex,
    required this.narration,
  });

  final int ledgerId;
  static const String ledgerIdKey = "ledgerId";

  final int amount;
  static const String amountKey = "amount";

  final int currencyConversionId;
  static const String currencyConversionIdKey = "currencyConversionId";

  final String chequeNo;
  static const String chequeNoKey = "chequeNo";

  final String? chequeDate;
  static const String chequeDateKey = "chequeDate";

  final int lineIndex;
  static const String lineIndexKey = "lineIndex";

  final String narration;
  static const String narrationKey = "narration";


  PaymentDetail copyWith({
    int? ledgerId,
    int? amount,
    int? currencyConversionId,
    String? chequeNo,
    String? chequeDate,
    int? lineIndex,
    String? narration,
  }) {
    return PaymentDetail(
      ledgerId: ledgerId ?? this.ledgerId,
      amount: amount ?? this.amount,
      currencyConversionId: currencyConversionId ?? this.currencyConversionId,
      chequeNo: chequeNo ?? this.chequeNo,
      chequeDate: chequeDate ?? this.chequeDate,
      lineIndex: lineIndex ?? this.lineIndex,
      narration: narration ?? this.narration,
    );
  }

  factory PaymentDetail.fromJson(Map<String, dynamic> json){
    return PaymentDetail(
      ledgerId: json["ledgerId"] ?? 0,
      amount: json["amount"] ?? 0,
      currencyConversionId: json["currencyConversionId"] ?? 0,
      chequeNo: json["chequeNo"] ?? "",
      chequeDate: json["chequeDate"] ?? "",
      lineIndex: json["lineIndex"] ?? 0,
      narration: json["narration"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "ledgerId": ledgerId,
    "amount": amount,
    "currencyConversionId": currencyConversionId,
    "chequeNo": chequeNo,
    "chequeDate": chequeDate,
    "lineIndex": lineIndex,
    "narration": narration,
  };

  @override
  String toString(){
    return "$ledgerId, $amount, $currencyConversionId, $chequeNo, $chequeDate, $lineIndex, $narration, ";
  }

  @override
  List<Object?> get props => [
    ledgerId, amount, currencyConversionId, chequeNo, chequeDate, lineIndex, narration, ];
}
