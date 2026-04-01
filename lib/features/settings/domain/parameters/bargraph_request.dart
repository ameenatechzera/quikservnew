class BarGraphRequest {
  final String period;
  final String branchId;


  BarGraphRequest({
    required this.period,
    required this.branchId
  });

  Map<String, dynamic> toJson() {
    return {
      "period": period,
      "branchId": branchId
    };
  }
}