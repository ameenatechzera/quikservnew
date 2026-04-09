import 'package:quikservnew/features/settings/domain/entities/weekly_graph_report_result.dart';

class WeeklyGraphReportModel extends WeeklyGraphReportResult {
  const WeeklyGraphReportModel({required super.period, required super.data});
  factory WeeklyGraphReportModel.fromJson(Map<String, dynamic> json) {
    return WeeklyGraphReportModel(
      period: json["period"] ?? "",
      data: json["data"] == null
          ? []
          : List<WeeklyList>.from(
              json["data"]!.map((x) => WeeklyList.fromJson(x)),
            ),
    );
  }
}
