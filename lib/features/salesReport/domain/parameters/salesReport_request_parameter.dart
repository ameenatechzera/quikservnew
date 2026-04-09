class FetchReportRequest {
  final String fromDate;
  final String toDate;
  final String userId;
  final String branchId;

  FetchReportRequest({
    required this.fromDate,
    required this.toDate,
    required this.userId,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "from_date": fromDate,
      "to_date": toDate,
      "user_id": userId,
      "branchId": branchId,
    };
  }
}
