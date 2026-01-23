class ItemWiseReportRequest {
  final String FromDate;
  final String ToDate;
  final String branchId;


  ItemWiseReportRequest({
    required this.FromDate,
    required this.ToDate,
    required this.branchId,


  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'FromDate': FromDate, // API expects "group_name"
      'ToDate': ToDate,
      'branchId': branchId

    };
  }
}