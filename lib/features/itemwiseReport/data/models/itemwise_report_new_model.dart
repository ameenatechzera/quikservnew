import 'package:quikservnew/features/itemwiseReport/data/models/product_model.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_reportnew.dart';

class ItemWiseReportModelNew extends ItemWiseReportResult {
  const ItemWiseReportModelNew({
    required super.status,
    required super.error,
    required super.message,
    required super.summaryReport,
  });

  factory ItemWiseReportModelNew.fromJson(Map<String, dynamic> json) {
    SummaryReportNew? report;
    final summary = json["summary_report"];
    if (summary is Map<String, dynamic>) {
      report = SummaryReportModelNew.fromJson(summary);
    }
    return ItemWiseReportModelNew(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      summaryReport: report,
    );
  }
}

class SummaryReportModelNew extends SummaryReportNew {
  const SummaryReportModelNew({required super.categories});

  factory SummaryReportModelNew.fromJson(Map<String, dynamic> json) {
    final Map<String, List<ItemProduct>> data = {};

    json.forEach((key, value) {
      data[key] = (value as List)
          .map((e) => ItemProductModel.fromJson(e))
          .toList();
    });
    return SummaryReportModelNew(categories: data);
  }
}
