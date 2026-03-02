class CustomSalesGraphRequest {
  final String period;
  final String branchId;
  final String fromDate;
  final String toDate;
  final String month;
  final String year;
  final String week;


  CustomSalesGraphRequest({
    required this.period,
    required this.branchId,
    required this.fromDate,
    required this.toDate,
    required this.month,
    required this.year,
    required this.week
  });

  Map<String, dynamic> toJson() {
    return {
      "period": period,
      "branchId": branchId,
      "fromDate": fromDate,
      "toDate": toDate,
      "month": month,
      "year": year,
      "week": week
    };
  }
}