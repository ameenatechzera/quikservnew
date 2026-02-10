class SavePaymentVoucherParameter {
  final int? branchId;
  final String? voucherType;
  final int? yearId;
  final String? date;
  final int? ledgerId;
  final String? narration;
  final double? totalAmount;
  final int? costCentreId;
  final String? referenceNo;
  final String? referenceDate;
  final int? postedStatus;
  final String? postedBy;
  final String? postedDate;
  final double? exchangeRate;
  final String? exchangeDate;
  final String? createdUser;
  final List<SavePaymentDetail>? paymentDetails;
  final List<SavePartyDetail>? partyDetails;

  SavePaymentVoucherParameter({
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

  factory SavePaymentVoucherParameter.fromJson(Map<String, dynamic> json) {
    return SavePaymentVoucherParameter(
      branchId: json['branchId'],
      voucherType: json['voucherType'],
      yearId: json['yearId'],
      date: json['date'],
      ledgerId: json['ledgerId'],
      narration: json['narration'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      costCentreId: json['costCentreId'],
      referenceNo: json['ReferenceNo'],
      referenceDate: json['ReferenceDate'],
      postedStatus: json['postedStatus'],
      postedBy: json['postedBy'],
      postedDate: json['postedDate'],
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
      exchangeDate: json['exchangeDate'],
      createdUser: json['CreatedUser'],
      paymentDetails: (json['paymentDetails'] as List?)
          ?.map((e) => SavePaymentDetail.fromJson(e))
          .toList(),
      partyDetails: (json['partyDetails'] as List?)
          ?.map((e) => SavePartyDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "paymentDetails": paymentDetails?.map((e) => e.toJson()).toList(),
      "partyDetails": partyDetails?.map((e) => e.toJson()).toList(),
    };
  }
}

class SavePaymentDetail {
  final int? ledgerId;
  final double? amount;
  final int? currencyConversionId;
  final String? chequeNo;
  final String? chequeDate;
  final int? lineIndex;
  final String? narration;

  SavePaymentDetail({
    this.ledgerId,
    this.amount,
    this.currencyConversionId,
    this.chequeNo,
    this.chequeDate,
    this.lineIndex,
    this.narration,
  });

  factory SavePaymentDetail.fromJson(Map<String, dynamic> json) {
    return SavePaymentDetail(
      ledgerId: json['ledgerId'],
      amount: (json['amount'] as num?)?.toDouble(),
      currencyConversionId: json['currencyConversionId'],
      chequeNo: json['chequeNo'],
      chequeDate: json['chequeDate'],
      lineIndex: json['lineIndex'],
      narration: json['narration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ledgerId": ledgerId,
      "amount": amount,
      "currencyConversionId": currencyConversionId,
      "chequeNo": chequeNo,
      "chequeDate": chequeDate,
      "lineIndex": lineIndex,
      "narration": narration,
    };
  }
}

class SavePartyDetail {
  final String? date;
  final String? againstVoucherType;
  final String? againstVoucherNo;
  final String? referenceType;
  final double? amount;
  final int? creditPeriod;
  final int? currencyConversionId;
  final String? referenceNo;
  final double? billAmount;

  SavePartyDetail({
    required this.date,
    required this.againstVoucherType,
    required this.againstVoucherNo,
    required this.referenceType,
    required this.amount,
    required this.creditPeriod,
    required this.currencyConversionId,
    required this.referenceNo,
    required this.billAmount,
  });

  factory SavePartyDetail.fromJson(Map<String, dynamic> json) {
    return SavePartyDetail(
      date: json['date'],
      againstVoucherType: json['againstVoucherType'],
      againstVoucherNo: json['againstvoucherNo'],
      referenceType: json['referenceType'],
      amount: (json['Amount'] as num?)?.toDouble(),
      creditPeriod: json['creditPeriod'],
      currencyConversionId: json['currencyConversionId'],
      referenceNo: json['referenceNo'],
      billAmount: (json['BillAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "againstVoucherType": againstVoucherType,
      "againstvoucherNo": againstVoucherNo,
      "referenceType": referenceType,
      "Amount": amount,
      "creditPeriod": creditPeriod,
      "currencyConversionId": currencyConversionId,
      "referenceNo": referenceNo,
      "BillAmount": billAmount,
    };
  }
}
