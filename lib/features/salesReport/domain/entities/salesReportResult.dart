import 'package:equatable/equatable.dart';

class SalesReportResult extends Equatable {
  SalesReportResult({
    required this.status,
    required this.error,
    required this.message,
    required this.salesMaster,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<SalesMaster> salesMaster;
  static const String salesMasterKey = "sales_master";


  SalesReportResult copyWith({
    int? status,
    bool? error,
    String? message,
    List<SalesMaster>? salesMaster,
  }) {
    return SalesReportResult(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      salesMaster: salesMaster ?? this.salesMaster,
    );
  }

  factory SalesReportResult.fromJson(Map<String, dynamic> json){
    return SalesReportResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      salesMaster: json["sales_master"] == null ? [] : List<SalesMaster>.from(json["sales_master"]!.map((x) => SalesMaster.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "sales_master": salesMaster.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $salesMaster, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, salesMaster, ];
}

class SalesMaster extends Equatable {
  SalesMaster({
    required this.salesMasterId,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.invoiceTime,
    required this.ledgerId,
    required this.subTotal,
    required this.discountAmount,
    required this.vatAmount,
    required this.grandTotal,
    required this.cashLedgerId,
    required this.cashAmount,
    required this.cardLedgerId,
    required this.cardAmount,
    required this.creditAmount,
    required this.tableId,
    required this.supplierId,
    required this.cashierId,
    required this.orderMasterId,
    required this.billStatus,
    required this.salesType,
    required this.billTokenNo,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
    required this.branchId,
    required this.ledgerName,
    required this.cashLedgerName,
    required this.cardLedgerName,
  });

  final int salesMasterId;
  static const String salesMasterIdKey = "SalesMasterId";

  final String invoiceNo;
  static const String invoiceNoKey = "InvoiceNo";

  final String? invoiceDate;
  static const String invoiceDateKey = "InvoiceDate";

  final String invoiceTime;
  static const String invoiceTimeKey = "InvoiceTime";

  final int ledgerId;
  static const String ledgerIdKey = "LedgerId";

  final String subTotal;
  static const String subTotalKey = "SubTotal";

  final String discountAmount;
  static const String discountAmountKey = "DiscountAmount";

  final String vatAmount;
  static const String vatAmountKey = "VatAmount";

  final String grandTotal;
  static const String grandTotalKey = "GrandTotal";

  final int cashLedgerId;
  static const String cashLedgerIdKey = "CashLedgerId";

  final String cashAmount;
  static const String cashAmountKey = "CashAmount";

  final int cardLedgerId;
  static const String cardLedgerIdKey = "CardLedgerID";

  final String cardAmount;
  static const String cardAmountKey = "CardAmount";

  final String creditAmount;
  static const String creditAmountKey = "creditAmount";

  final int tableId;
  static const String tableIdKey = "table_id";

  final int supplierId;
  static const String supplierIdKey = "supplierId";

  final int cashierId;
  static const String cashierIdKey = "cashierId";

  final int orderMasterId;
  static const String orderMasterIdKey = "orderMasterId";

  final String billStatus;
  static const String billStatusKey = "BillStatus";

  final String salesType;
  static const String salesTypeKey = "salesType";

  final int billTokenNo;
  static const String billTokenNoKey = "billTokenNo";

  final String? createdDate;
  static const String createdDateKey = "CreatedDate";

  final String createdUser;
  static const String createdUserKey = "CreatedUser";

  final String modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final String modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";

  final int branchId;
  static const String branchIdKey = "branchId";

  final String ledgerName;
  static const String ledgerNameKey = "ledger_name";

  final String cashLedgerName;
  static const String cashLedgerNameKey = "cashLedgerName";

  final String cardLedgerName;
  static const String cardLedgerNameKey = "cardLedgerName";


  SalesMaster copyWith({
    int? salesMasterId,
    String? invoiceNo,
    String? invoiceDate,
    String? invoiceTime,
    int? ledgerId,
    String? subTotal,
    String? discountAmount,
    String? vatAmount,
    String? grandTotal,
    int? cashLedgerId,
    String? cashAmount,
    int? cardLedgerId,
    String? cardAmount,
    String? creditAmount,
    int? tableId,
    int? supplierId,
    int? cashierId,
    int? orderMasterId,
    String? billStatus,
    String? salesType,
    int? billTokenNo,
    String? createdDate,
    String? createdUser,
    String? modifiedDate,
    String? modifiedUser,
    int? branchId,
    String? ledgerName,
    String? cashLedgerName,
    String? cardLedgerName,
  }) {
    return SalesMaster(
      salesMasterId: salesMasterId ?? this.salesMasterId,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      invoiceTime: invoiceTime ?? this.invoiceTime,
      ledgerId: ledgerId ?? this.ledgerId,
      subTotal: subTotal ?? this.subTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      vatAmount: vatAmount ?? this.vatAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      cashLedgerId: cashLedgerId ?? this.cashLedgerId,
      cashAmount: cashAmount ?? this.cashAmount,
      cardLedgerId: cardLedgerId ?? this.cardLedgerId,
      cardAmount: cardAmount ?? this.cardAmount,
      creditAmount: creditAmount ?? this.creditAmount,
      tableId: tableId ?? this.tableId,
      supplierId: supplierId ?? this.supplierId,
      cashierId: cashierId ?? this.cashierId,
      orderMasterId: orderMasterId ?? this.orderMasterId,
      billStatus: billStatus ?? this.billStatus,
      salesType: salesType ?? this.salesType,
      billTokenNo: billTokenNo ?? this.billTokenNo,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
      branchId: branchId ?? this.branchId,
      ledgerName: ledgerName ?? this.ledgerName,
      cashLedgerName: cashLedgerName ?? this.cashLedgerName,
      cardLedgerName: cardLedgerName ?? this.cardLedgerName,
    );
  }

  factory SalesMaster.fromJson(Map<String, dynamic> json){
    return SalesMaster(
      salesMasterId: json["SalesMasterId"] ?? 0,
      invoiceNo: json["InvoiceNo"] ?? "",
      invoiceDate: json["InvoiceDate"] ?? "",
      invoiceTime: json["InvoiceTime"] ?? "",
      ledgerId: json["LedgerId"] ?? 0,
      subTotal: json["SubTotal"] ?? "",
      discountAmount: json["DiscountAmount"] ?? "",
      vatAmount: json["VatAmount"] ?? "",
      grandTotal: json["GrandTotal"] ?? "",
      cashLedgerId: json["CashLedgerId"] ?? 0,
      cashAmount: json["CashAmount"] ?? "",
      cardLedgerId: json["CardLedgerID"] ?? 0,
      cardAmount: json["CardAmount"] ?? "",
      creditAmount: json["creditAmount"] ?? "",
      tableId: json["table_id"] ?? 0,
      supplierId: json["supplierId"] ?? 0,
      cashierId: json["cashierId"] ?? 0,
      orderMasterId: json["orderMasterId"] ?? 0,
      billStatus: json["BillStatus"] ?? "",
      salesType: json["salesType"] ?? "",
      billTokenNo: json["billTokenNo"] ?? 0,
      createdDate: json["CreatedDate"] ?? "",
      createdUser: json["CreatedUser"] ?? "",
      modifiedDate: json["ModifiedDate"] ?? "",
      modifiedUser: json["ModifiedUser"] ?? "",
      branchId: json["branchId"] ?? 0,
      ledgerName: json["ledger_name"] ?? "",
      cashLedgerName: json["cashLedgerName"] ?? "",
      cardLedgerName: json["cardLedgerName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "SalesMasterId": salesMasterId,
    "InvoiceNo": invoiceNo,
    "InvoiceDate": invoiceDate,
    "InvoiceTime": invoiceTime,
    "LedgerId": ledgerId,
    "SubTotal": subTotal,
    "DiscountAmount": discountAmount,
    "VatAmount": vatAmount,
    "GrandTotal": grandTotal,
    "CashLedgerId": cashLedgerId,
    "CashAmount": cashAmount,
    "CardLedgerID": cardLedgerId,
    "CardAmount": cardAmount,
    "creditAmount": creditAmount,
    "table_id": tableId,
    "supplierId": supplierId,
    "cashierId": cashierId,
    "orderMasterId": orderMasterId,
    "BillStatus": billStatus,
    "salesType": salesType,
    "billTokenNo": billTokenNo,
    "CreatedDate": createdDate,
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
    "branchId": branchId,
    "ledger_name": ledgerName,
    "cashLedgerName": cashLedgerName,
    "cardLedgerName": cardLedgerName,
  };

  @override
  String toString(){
    return "$salesMasterId, $invoiceNo, $invoiceDate, $invoiceTime, $ledgerId, $subTotal, $discountAmount, $vatAmount, $grandTotal, $cashLedgerId, $cashAmount, $cardLedgerId, $cardAmount, $creditAmount, $tableId, $supplierId, $cashierId, $orderMasterId, $billStatus, $salesType, $billTokenNo, $createdDate, $createdUser, $modifiedDate, $modifiedUser, $branchId, $ledgerName, $cashLedgerName, $cardLedgerName, ";
  }

  @override
  List<Object?> get props => [
    salesMasterId, invoiceNo, invoiceDate, invoiceTime, ledgerId, subTotal, discountAmount, vatAmount, grandTotal, cashLedgerId, cashAmount, cardLedgerId, cardAmount, creditAmount, tableId, supplierId, cashierId, orderMasterId, billStatus, salesType, billTokenNo, createdDate, createdUser, modifiedDate, modifiedUser, branchId, ledgerName, cashLedgerName, cardLedgerName, ];
}
