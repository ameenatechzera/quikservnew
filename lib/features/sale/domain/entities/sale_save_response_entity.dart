class SalesResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final SalesDetailsEntity? details;

  SalesResponseEntity({this.status, this.error, this.message, this.details});
}

class SalesDetailsEntity {
  final int? salesMasterId;
  final String? invoiceNo;
  final String? currentDate;

  SalesDetailsEntity({this.salesMasterId, this.invoiceNo, this.currentDate});
}
