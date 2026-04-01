class CustomSalesGraphRequest {
  final String? period;
  final String? branchId;
  final String? fromDate;
  final String? toDate;
  final String? month;
  final String? year;
  final String? week;
  final String? salesType;

  CustomSalesGraphRequest({
    this.period,
    this.branchId,
    this.fromDate,
    this.toDate,
    this.month,
    this.year,
    this.week,
    this.salesType
  });

  Map<String, dynamic> toJson() {
    return {
      "period": _nullIfEmpty(period),
      "branchId": _nullIfEmpty(branchId),
      "fromDate": _nullIfEmpty(fromDate),
      "toDate": _nullIfEmpty(toDate),
      "month": _nullIfEmpty(month),
      "year": _nullIfEmpty(year),
      "week": _nullIfEmpty(week),
      "salesType":_nullIfEmpty(salesType),
    };
  }

  String? _nullIfEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }
}