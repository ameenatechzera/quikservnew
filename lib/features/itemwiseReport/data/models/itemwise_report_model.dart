import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';

class ItemWiseReportModel extends ItemwiseReportResponse{
  ItemWiseReportModel({required super.status, required super.error, required super.message, required super.summaryReport});

  factory ItemWiseReportModel.fromJson(Map<String, dynamic> json){
    return ItemWiseReportModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      summaryReport: json["summary_report"] == null ? [] : List<SummaryReport>.from(json["summary_report"]!.map((x) => SummaryReport.fromJson(x))),
    );
  }
}