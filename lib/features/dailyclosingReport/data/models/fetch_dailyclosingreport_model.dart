import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyclosingreport_result.dart';

class FetchDailyClosingReportModel extends DailyClosingReportResponse {
  FetchDailyClosingReportModel({
    required super.status,
    required super.error,
    required super.message,
    required super.summaryReport,
    required super.expenseDetails,
    required super.expenseTotal,
    required super.cashBalance,
    required super.bankBalance,
  });
  factory FetchDailyClosingReportModel.fromJson(Map<String, dynamic> json) {
    return FetchDailyClosingReportModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      summaryReport: json["summary_report"] == null
          ? []
          : List<SummaryReports>.from(
              json["summary_report"]!.map((x) => SummaryReports.fromJson(x)),
            ),
      expenseDetails: json["expense_details"] == null
          ? []
          : List<ExpenseDetail>.from(
              json["expense_details"]!.map((x) => ExpenseDetail.fromJson(x)),
            ),
      expenseTotal: json["expense_total"] ?? "",
      cashBalance: json["cash_balance"] ?? "",
      bankBalance: json["bank_balance"] ?? "",
    );
  }
}
