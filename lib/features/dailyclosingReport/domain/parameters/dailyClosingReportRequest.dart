class DailyCloseReportRequest {
  final String FromDate;
  final String ToDate;
  final String branchId;


  DailyCloseReportRequest({
    required this.FromDate,
    required this.ToDate,
    required this.branchId,


  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'from_date': FromDate, // API expects "group_name"
      'to_date': ToDate,
      'branchId': branchId

    };
  }
}