import 'package:equatable/equatable.dart';

class PaymentVoucherResponse extends Equatable {
  PaymentVoucherResponse({
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

  final Data? data;
  static const String dataKey = "data";


  PaymentVoucherResponse copyWith({
    int? status,
    bool? error,
    String? message,
    Data? data,
  }) {
    return PaymentVoucherResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory PaymentVoucherResponse.fromJson(Map<String, dynamic> json){
    return PaymentVoucherResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, data, ];
}

class Data extends Equatable {
  Data({
    required this.paymentMasterId,
    required this.voucherNo,
    required this.suffixPrefixId,
    required this.paymentNo,
    required this.date,
    required this.ledgerId,
    required this.ledgerName,
    required this.narration,
    required this.totalAmount,
    required this.costCentreId,
    required this.referenceNo,
    required this.referenceDate,
    required this.postedStatus,
    required this.postedBy,
    required this.postedDate,
    required this.branchId,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
    required this.paymentDetails,
  });

  final int paymentMasterId;
  static const String paymentMasterIdKey = "paymentMasterId";

  final String voucherNo;
  static const String voucherNoKey = "voucherNo";

  final int suffixPrefixId;
  static const String suffixPrefixIdKey = "suffixPrefixId";

  final String paymentNo;
  static const String paymentNoKey = "paymentNo";

  final DateTime? date;
  static const String dateKey = "date";

  final int ledgerId;
  static const String ledgerIdKey = "ledgerId";

  final String ledgerName;
  static const String ledgerNameKey = "ledgerName";

  final String narration;
  static const String narrationKey = "narration";

  final String totalAmount;
  static const String totalAmountKey = "totalAmount";

  final dynamic costCentreId;
  static const String costCentreIdKey = "costCentreId";

  final String referenceNo;
  static const String referenceNoKey = "ReferenceNo";

  final DateTime? referenceDate;
  static const String referenceDateKey = "ReferenceDate";

  final String postedStatus;
  static const String postedStatusKey = "postedStatus";

  final String postedBy;
  static const String postedByKey = "postedBy";

  final DateTime? postedDate;
  static const String postedDateKey = "postedDate";

  final int branchId;
  static const String branchIdKey = "branchId";

  final DateTime? createdDate;
  static const String createdDateKey = "CreatedDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";

  final List<PaymentDetail> paymentDetails;
  static const String paymentDetailsKey = "paymentDetails";


  Data copyWith({
    int? paymentMasterId,
    String? voucherNo,
    int? suffixPrefixId,
    String? paymentNo,
    DateTime? date,
    int? ledgerId,
    String? ledgerName,
    String? narration,
    String? totalAmount,
    dynamic? costCentreId,
    String? referenceNo,
    DateTime? referenceDate,
    String? postedStatus,
    String? postedBy,
    DateTime? postedDate,
    int? branchId,
    DateTime? createdDate,
    String? createdUser,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
    List<PaymentDetail>? paymentDetails,
  }) {
    return Data(
      paymentMasterId: paymentMasterId ?? this.paymentMasterId,
      voucherNo: voucherNo ?? this.voucherNo,
      suffixPrefixId: suffixPrefixId ?? this.suffixPrefixId,
      paymentNo: paymentNo ?? this.paymentNo,
      date: date ?? this.date,
      ledgerId: ledgerId ?? this.ledgerId,
      ledgerName: ledgerName ?? this.ledgerName,
      narration: narration ?? this.narration,
      totalAmount: totalAmount ?? this.totalAmount,
      costCentreId: costCentreId ?? this.costCentreId,
      referenceNo: referenceNo ?? this.referenceNo,
      referenceDate: referenceDate ?? this.referenceDate,
      postedStatus: postedStatus ?? this.postedStatus,
      postedBy: postedBy ?? this.postedBy,
      postedDate: postedDate ?? this.postedDate,
      branchId: branchId ?? this.branchId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      paymentMasterId: json["paymentMasterId"] ?? 0,
      voucherNo: json["voucherNo"] ?? "",
      suffixPrefixId: json["suffixPrefixId"] ?? 0,
      paymentNo: json["paymentNo"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      ledgerId: json["ledgerId"] ?? 0,
      ledgerName: json["ledgerName"] ?? "",
      narration: json["narration"] ?? "",
      totalAmount: json["totalAmount"] ?? "",
      costCentreId: json["costCentreId"],
      referenceNo: json["ReferenceNo"] ?? "",
      referenceDate: DateTime.tryParse(json["ReferenceDate"] ?? ""),
      postedStatus: json["postedStatus"] ?? "",
      postedBy: json["postedBy"] ?? "",
      postedDate: DateTime.tryParse(json["postedDate"] ?? ""),
      branchId: json["branchId"] ?? 0,
      createdDate: DateTime.tryParse(json["CreatedDate"] ?? ""),
      createdUser: json["CreatedUser"] ?? "",
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
      paymentDetails: json["paymentDetails"] == null ? [] : List<PaymentDetail>.from(json["paymentDetails"]!.map((x) => PaymentDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "paymentMasterId": paymentMasterId,
    "voucherNo": voucherNo,
    "suffixPrefixId": suffixPrefixId,
    "paymentNo": paymentNo,
    "date": date?.toIso8601String(),
    "ledgerId": ledgerId,
    "ledgerName": ledgerName,
    "narration": narration,
    "totalAmount": totalAmount,
    "costCentreId": costCentreId,
    "ReferenceNo": referenceNo,
    "ReferenceDate": referenceDate?.toIso8601String(),
    "postedStatus": postedStatus,
    "postedBy": postedBy,
    "postedDate": postedDate?.toIso8601String(),
    "branchId": branchId,
    "CreatedDate": createdDate?.toIso8601String(),
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
    "paymentDetails": paymentDetails.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$paymentMasterId, $voucherNo, $suffixPrefixId, $paymentNo, $date, $ledgerId, $ledgerName, $narration, $totalAmount, $costCentreId, $referenceNo, $referenceDate, $postedStatus, $postedBy, $postedDate, $branchId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, $paymentDetails, ";
  }

  @override
  List<Object?> get props => [
    paymentMasterId, voucherNo, suffixPrefixId, paymentNo, date, ledgerId, ledgerName, narration, totalAmount, costCentreId, referenceNo, referenceDate, postedStatus, postedBy, postedDate, branchId, createdDate, createdUser, modifiedDate, modifiedUser, paymentDetails, ];
}

class PaymentDetail extends Equatable {
  PaymentDetail({
    required this.paymentDetailsId,
    required this.paymentMasterId,
    required this.ledgerId,
    required this.ledgerName,
    required this.amount,
    required this.currencyConversionId,
    required this.exchangeRate,
    required this.exchangeDate,
    required this.chequeNo,
    required this.chequeDate,
    required this.lineIndex,
    required this.narration,
    required this.branchId,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
  });

  final int paymentDetailsId;
  static const String paymentDetailsIdKey = "paymentDetailsId";

  final int paymentMasterId;
  static const String paymentMasterIdKey = "paymentMasterId";

  final int ledgerId;
  static const String ledgerIdKey = "ledgerId";

  final String ledgerName;
  static const String ledgerNameKey = "ledgerName";

  final String amount;
  static const String amountKey = "amount";

  final int currencyConversionId;
  static const String currencyConversionIdKey = "currencyConversionId";

  final String exchangeRate;
  static const String exchangeRateKey = "exchangeRate";

  final DateTime? exchangeDate;
  static const String exchangeDateKey = "exchangeDate";

  final String chequeNo;
  static const String chequeNoKey = "chequeNo";

  final DateTime? chequeDate;
  static const String chequeDateKey = "chequeDate";

  final int lineIndex;
  static const String lineIndexKey = "lineIndex";

  final String narration;
  static const String narrationKey = "Narration";

  final int branchId;
  static const String branchIdKey = "branchId";

  final DateTime? createdDate;
  static const String createdDateKey = "CreatedDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";


  PaymentDetail copyWith({
    int? paymentDetailsId,
    int? paymentMasterId,
    int? ledgerId,
    String? ledgerName,
    String? amount,
    int? currencyConversionId,
    String? exchangeRate,
    DateTime? exchangeDate,
    String? chequeNo,
    DateTime? chequeDate,
    int? lineIndex,
    String? narration,
    int? branchId,
    DateTime? createdDate,
    String? createdUser,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
  }) {
    return PaymentDetail(
      paymentDetailsId: paymentDetailsId ?? this.paymentDetailsId,
      paymentMasterId: paymentMasterId ?? this.paymentMasterId,
      ledgerId: ledgerId ?? this.ledgerId,
      ledgerName: ledgerName ?? this.ledgerName,
      amount: amount ?? this.amount,
      currencyConversionId: currencyConversionId ?? this.currencyConversionId,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      exchangeDate: exchangeDate ?? this.exchangeDate,
      chequeNo: chequeNo ?? this.chequeNo,
      chequeDate: chequeDate ?? this.chequeDate,
      lineIndex: lineIndex ?? this.lineIndex,
      narration: narration ?? this.narration,
      branchId: branchId ?? this.branchId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
    );
  }

  factory PaymentDetail.fromJson(Map<String, dynamic> json){
    return PaymentDetail(
      paymentDetailsId: json["paymentDetailsId"] ?? 0,
      paymentMasterId: json["paymentMasterId"] ?? 0,
      ledgerId: json["ledgerId"] ?? 0,
      ledgerName: json["ledgerName"] ?? "",
      amount: json["amount"] ?? "",
      currencyConversionId: json["currencyConversionId"] ?? 0,
      exchangeRate: json["exchangeRate"] ?? "",
      exchangeDate: DateTime.tryParse(json["exchangeDate"] ?? ""),
      chequeNo: json["chequeNo"] ?? "",
      chequeDate: DateTime.tryParse(json["chequeDate"] ?? ""),
      lineIndex: json["lineIndex"] ?? 0,
      narration: json["Narration"] ?? "",
      branchId: json["branchId"] ?? 0,
      createdDate: DateTime.tryParse(json["CreatedDate"] ?? ""),
      createdUser: json["CreatedUser"] ?? "",
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
    );
  }

  Map<String, dynamic> toJson() => {
    "paymentDetailsId": paymentDetailsId,
    "paymentMasterId": paymentMasterId,
    "ledgerId": ledgerId,
    "ledgerName": ledgerName,
    "amount": amount,
    "currencyConversionId": currencyConversionId,
    "exchangeRate": exchangeRate,
    "exchangeDate": exchangeDate?.toIso8601String(),
    "chequeNo": chequeNo,
    "chequeDate": chequeDate?.toIso8601String(),
    "lineIndex": lineIndex,
    "Narration": narration,
    "branchId": branchId,
    "CreatedDate": createdDate?.toIso8601String(),
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
  };

  @override
  String toString(){
    return "$paymentDetailsId, $paymentMasterId, $ledgerId, $ledgerName, $amount, $currencyConversionId, $exchangeRate, $exchangeDate, $chequeNo, $chequeDate, $lineIndex, $narration, $branchId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, ";
  }

  @override
  List<Object?> get props => [
    paymentDetailsId, paymentMasterId, ledgerId, ledgerName, amount, currencyConversionId, exchangeRate, exchangeDate, chequeNo, chequeDate, lineIndex, narration, branchId, createdDate, createdUser, modifiedDate, modifiedUser, ];
}
