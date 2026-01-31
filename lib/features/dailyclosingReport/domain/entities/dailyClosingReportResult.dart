import 'package:equatable/equatable.dart';

class DailyClosingReportResponse extends Equatable {
  DailyClosingReportResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.summaryReport,
    required this.expenseDetails,
    required this.expenseTotal,
    required this.cashBalance,
    required this.bankBalance,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<SummaryReports> summaryReport;
  static const String summaryReportKey = "summary_report";

  final List<ExpenseDetail> expenseDetails;
  static const String expenseDetailsKey = "expense_details";

  final String expenseTotal;
  static const String expenseTotalKey = "expense_total";

  final String cashBalance;
  static const String cashBalanceKey = "cash_balance";

  final String bankBalance;
  static const String bankBalanceKey = "bank_balance";

  DailyClosingReportResponse copyWith({
    int? status,
    bool? error,
    String? message,
    List<SummaryReports>? summaryReport,
    List<ExpenseDetail>? expenseDetails,
    String? expenseTotal,
    String? cashBalance,
    String? bankBalance,
  }) {
    return DailyClosingReportResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      summaryReport: summaryReport ?? this.summaryReport,
      expenseDetails: expenseDetails ?? this.expenseDetails,
      expenseTotal: expenseTotal ?? this.expenseTotal,
      cashBalance: cashBalance ?? this.cashBalance,
      bankBalance: bankBalance ?? this.bankBalance,
    );
  }

  factory DailyClosingReportResponse.fromJson(Map<String, dynamic> json) {
    return DailyClosingReportResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      summaryReport: json["summary_report"] == null
          ? []
          : List<SummaryReports>.from(
              json["summary_report"]!.map((x) => SummaryReports.fromJson(x)),
            ),
      expenseDetails: json["expense_details"] == null
          ? []
          : List<ExpenseDetail>.from(
              json["expense_details"]!.map((x) => ExpenseDetail.fromJson(x)),
            ),
      expenseTotal: json["expense_total"] ?? "",
      cashBalance: json["cash_balance"] ?? "",
      bankBalance: json["bank_balance"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "summary_report": summaryReport.map((x) => x.toJson()).toList(),
    "expense_details": expenseDetails.map((x) => x.toJson()).toList(),
    "expense_total": expenseTotal,
    "cash_balance": cashBalance,
    "bank_balance": bankBalance,
  };

  @override
  String toString() {
    return "$status, $error, $message, $summaryReport, $expenseDetails, $expenseTotal, $cashBalance, $bankBalance, ";
  }

  @override
  List<Object?> get props => [
    status,
    error,
    message,
    summaryReport,
    expenseDetails,
    expenseTotal,
    cashBalance,
    bankBalance,
  ];
}

class ExpenseDetail extends Equatable {
  ExpenseDetail({
    required this.paymentMasterId,
    required this.paymentNo,
    required this.paymentDate,
    required this.cashBankLedgerId,
    required this.ledgerId,
    required this.ledgerType,
    required this.amount,
    required this.narration,
    required this.branchId,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
    required this.ledgerName,
  });

  final int paymentMasterId;
  static const String paymentMasterIdKey = "paymentMasterId";

  final String paymentNo;
  static const String paymentNoKey = "PaymentNo";

  final String? paymentDate;
  static const String paymentDateKey = "PaymentDate";

  final dynamic cashBankLedgerId;
  static const String cashBankLedgerIdKey = "CashBankLedgerId";

  final int ledgerId;
  static const String ledgerIdKey = "LedgerId";

  final dynamic ledgerType;
  static const String ledgerTypeKey = "ledger_type";

  final String amount;
  static const String amountKey = "Amount";

  final dynamic narration;
  static const String narrationKey = "Narration";

  final int branchId;
  static const String branchIdKey = "branchId";

  final dynamic createdDate;
  static const String createdDateKey = "CreatedDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final String? modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";

  final String ledgerName;
  static const String ledgerNameKey = "ledger_name";

  ExpenseDetail copyWith({
    int? paymentMasterId,
    String? paymentNo,
    String? paymentDate,
    dynamic cashBankLedgerId,
    int? ledgerId,
    dynamic ledgerType,
    String? amount,
    dynamic narration,
    int? branchId,
    dynamic createdDate,
    String? createdUser,
    String? modifiedDate,
    dynamic modifiedUser,
    String? ledgerName,
  }) {
    return ExpenseDetail(
      paymentMasterId: paymentMasterId ?? this.paymentMasterId,
      paymentNo: paymentNo ?? this.paymentNo,
      paymentDate: paymentDate ?? this.paymentDate,
      cashBankLedgerId: cashBankLedgerId ?? this.cashBankLedgerId,
      ledgerId: ledgerId ?? this.ledgerId,
      ledgerType: ledgerType ?? this.ledgerType,
      amount: amount ?? this.amount,
      narration: narration ?? this.narration,
      branchId: branchId ?? this.branchId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
      ledgerName: ledgerName ?? this.ledgerName,
    );
  }

  factory ExpenseDetail.fromJson(Map<String, dynamic> json) {
    return ExpenseDetail(
      paymentMasterId: json["paymentMasterId"] ?? 0,
      paymentNo: json["PaymentNo"] ?? "",
      paymentDate: json["PaymentDate"] ?? "",
      cashBankLedgerId: json["CashBankLedgerId"],
      ledgerId: json["LedgerId"] ?? 0,
      ledgerType: json["ledger_type"],
      amount: json["Amount"] ?? "",
      narration: json["Narration"],
      branchId: json["branchId"] ?? 0,
      createdDate: json["CreatedDate"],
      createdUser: json["CreatedUser"] ?? "",
      modifiedDate: json["ModifiedDate"] ?? "",
      modifiedUser: json["ModifiedUser"],
      ledgerName: json["ledger_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "paymentMasterId": paymentMasterId,
    "PaymentNo": paymentNo,
    "PaymentDate": paymentDate,
    "CashBankLedgerId": cashBankLedgerId,
    "LedgerId": ledgerId,
    "ledger_type": ledgerType,
    "Amount": amount,
    "Narration": narration,
    "branchId": branchId,
    "CreatedDate": createdDate,
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
    "ledger_name": ledgerName,
  };

  @override
  String toString() {
    return "$paymentMasterId, $paymentNo, $paymentDate, $cashBankLedgerId, $ledgerId, $ledgerType, $amount, $narration, $branchId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, $ledgerName, ";
  }

  @override
  List<Object?> get props => [
    paymentMasterId,
    paymentNo,
    paymentDate,
    cashBankLedgerId,
    ledgerId,
    ledgerType,
    amount,
    narration,
    branchId,
    createdDate,
    createdUser,
    modifiedDate,
    modifiedUser,
    ledgerName,
  ];
}

class SummaryReports extends Equatable {
  SummaryReports({
    required this.invoiceDate,
    required this.cashAmount,
    required this.cardAmount,
    required this.creditAmount,
  });

  final String? invoiceDate;
  static const String invoiceDateKey = "InvoiceDate";

  final String cashAmount;
  static const String cashAmountKey = "CashAmount";

  final String cardAmount;
  static const String cardAmountKey = "CardAmount";

  final String creditAmount;
  static const String creditAmountKey = "CreditAmount";

  SummaryReports copyWith({
    String? invoiceDate,
    String? cashAmount,
    String? cardAmount,
    String? creditAmount,
  }) {
    return SummaryReports(
      invoiceDate: invoiceDate ?? this.invoiceDate,
      cashAmount: cashAmount ?? this.cashAmount,
      cardAmount: cardAmount ?? this.cardAmount,
      creditAmount: creditAmount ?? this.creditAmount,
    );
  }

  factory SummaryReports.fromJson(Map<String, dynamic> json) {
    return SummaryReports(
      invoiceDate: json["InvoiceDate"] ?? "",
      cashAmount: json["CashAmount"] ?? "",
      cardAmount: json["CardAmount"] ?? "",
      creditAmount: json["CreditAmount"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "InvoiceDate": invoiceDate,
    "CashAmount": cashAmount,
    "CardAmount": cardAmount,
    "CreditAmount": creditAmount,
  };

  @override
  String toString() {
    return "$invoiceDate, $cashAmount, $cardAmount, $creditAmount, ";
  }

  @override
  List<Object?> get props => [
    invoiceDate,
    cashAmount,
    cardAmount,
    creditAmount,
  ];
}
