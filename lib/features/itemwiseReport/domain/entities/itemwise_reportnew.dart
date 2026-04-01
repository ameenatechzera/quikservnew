import 'package:equatable/equatable.dart';

class ItemWiseReportResult extends Equatable {
  final int status;
  final bool error;
  final String message;
  final SummaryReportNew? summaryReport;

  const ItemWiseReportResult({
    required this.status,
    required this.error,
    required this.message,
    this.summaryReport,
  });

  @override
  List<Object?> get props => [status, error, message, summaryReport];
}

class SummaryReportNew extends Equatable {

  final Map<String, List<ItemProduct>> categories;

  const SummaryReportNew({
    required this.categories,
  });

  @override
  List<Object?> get props => [categories];
}

class ItemProduct extends Equatable {

  final String productCode;
  final String productName;
  final int qty;
  final String subTotal;
  final String taxAmount;
  final String totalAmount;
  final String purchaseCost;
  final String categoryName;

  const ItemProduct({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.subTotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.purchaseCost,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [
    productCode,
    productName,
    qty,
    subTotal,
    taxAmount,
    totalAmount,
    purchaseCost,
    categoryName,
  ];
}