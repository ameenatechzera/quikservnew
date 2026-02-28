import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';

class MonthlyGraphModel extends MonthlyGraphReportResult{
  MonthlyGraphModel({required super.period, required super.data});
  factory MonthlyGraphModel.fromJson(Map<String, dynamic> json){
    return MonthlyGraphModel(
      period: json["period"] ?? "",
      data: json["data"] == null ? [] : List<MonthlyReportList>.from(json["data"]!.map((x) => MonthlyReportList.fromJson(x))),
    );
  }
}