import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';

class SalesCountGraphModel extends MonthlyGraphReportResult{
  SalesCountGraphModel({ required super.period, required super.data});

  // factory SalesCountGraphModel.fromJson(Map<String, dynamic> json){
  //   return SalesCountGraphModel(
  //     status: json["status"] ?? 0,
  //     error: json["error"] ?? false,
  //     period: json["period"] ?? "",
  //     data: json["data"] == null ? [] : List<SaleCountGraphList>.from(json["data"]!.map((x) => SaleCountGraphList.fromJson(x))),
  //   );
  // }
  factory SalesCountGraphModel.fromJson(Map<String, dynamic> json){
    return SalesCountGraphModel(
      period: json["period"] ?? "",
      data: json["data"] == null ? [] : List<MonthlyReportList>.from(json["data"]!.map((x) => MonthlyReportList.fromJson(x))),
    );
  }
}