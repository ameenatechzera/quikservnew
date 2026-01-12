class SalesReportMasterByDateRequest {
  final String fromDate;
  final String toDate;

  SalesReportMasterByDateRequest({
    required this.fromDate,
    required this.toDate,
  });

  Map<String, dynamic> toJson() => {"fromDate": fromDate, "toDate": toDate};
}
