class ItemWiseReportRequest {
  final String fromDate;
  final String toDate;
  final String branchId;

  ItemWiseReportRequest({
    required this.fromDate,
    required this.toDate,
    required this.branchId,
  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {'FromDate': fromDate, 'ToDate': toDate, 'branchId': branchId};
  }
}
