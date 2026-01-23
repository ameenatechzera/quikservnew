import 'package:equatable/equatable.dart';

class ItemwiseReportResponse extends Equatable {
  ItemwiseReportResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.summaryReport,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<SummaryReport> summaryReport;
  static const String summaryReportKey = "summary_report";


  ItemwiseReportResponse copyWith({
    int? status,
    bool? error,
    String? message,
    List<SummaryReport>? summaryReport,
  }) {
    return ItemwiseReportResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      summaryReport: summaryReport ?? this.summaryReport,
    );
  }

  factory ItemwiseReportResponse.fromJson(Map<String, dynamic> json){
    return ItemwiseReportResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      summaryReport: json["summary_report"] == null ? [] : List<SummaryReport>.from(json["summary_report"]!.map((x) => SummaryReport.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "summary_report": summaryReport.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $summaryReport, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, summaryReport, ];
}

class SummaryReport extends Equatable {
  SummaryReport({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.subTotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.purchaseCost,
    required this.categoryName,
  });

  final String productCode;
  static const String productCodeKey = "ProductCode";

  final String productName;
  static const String productNameKey = "ProductName";

  final int qty;
  static const String qtyKey = "Qty";

  final String subTotal;
  static const String subTotalKey = "SubTotal";

  final String taxAmount;
  static const String taxAmountKey = "TaxAmount";

  final String totalAmount;
  static const String totalAmountKey = "TotalAmount";

  final String purchaseCost;
  static const String purchaseCostKey = "PurchaseCost";

  final String categoryName;
  static const String categoryNameKey = "category_name";


  SummaryReport copyWith({
    String? productCode,
    String? productName,
    int? qty,
    String? subTotal,
    String? taxAmount,
    String? totalAmount,
    String? purchaseCost,
    String? categoryName,
  }) {
    return SummaryReport(
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      qty: qty ?? this.qty,
      subTotal: subTotal ?? this.subTotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  factory SummaryReport.fromJson(Map<String, dynamic> json){
    return SummaryReport(
      productCode: json["ProductCode"] ?? "",
      productName: json["ProductName"] ?? "",
      qty: json["Qty"] ?? 0,
      subTotal: json["SubTotal"] ?? "",
      taxAmount: json["TaxAmount"] ?? "",
      totalAmount: json["TotalAmount"] ?? "",
      purchaseCost: json["PurchaseCost"] ?? "",
      categoryName: json["category_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "ProductCode": productCode,
    "ProductName": productName,
    "Qty": qty,
    "SubTotal": subTotal,
    "TaxAmount": taxAmount,
    "TotalAmount": totalAmount,
    "PurchaseCost": purchaseCost,
    "category_name": categoryName,
  };

  @override
  String toString(){
    return "$productCode, $productName, $qty, $subTotal, $taxAmount, $totalAmount, $purchaseCost, $categoryName, ";
  }

  @override
  List<Object?> get props => [
    productCode, productName, qty, subTotal, taxAmount, totalAmount, purchaseCost, categoryName, ];
}
