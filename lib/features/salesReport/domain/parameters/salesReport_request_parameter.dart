class FetchReportRequest {
  final String from_date;
  final String to_date;
  final String user_id;
  final String branchId;

  FetchReportRequest({
    required this.from_date,
    required this.to_date,
    required this.user_id,
    required this.branchId
  });

  Map<String, dynamic> toJson() {
    return {
      "from_date": from_date,
      "to_date": to_date,
      "user_id": user_id,
      "branchId": branchId,

    };
  }
}
