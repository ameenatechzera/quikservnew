import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';

class SalesCountGraphModel extends MonthlyGraphReportResult {
  SalesCountGraphModel({required super.period, required super.data});
  factory SalesCountGraphModel.fromJson(Map<String, dynamic> json) {
    return SalesCountGraphModel(
      period: json["period"] ?? "",
      data: json["data"] == null
          ? []
          : List<MonthlyReportList>.from(
              json["data"]!.map((x) => MonthlyReportList.fromJson(x)),
            ),
    );
  }
}
