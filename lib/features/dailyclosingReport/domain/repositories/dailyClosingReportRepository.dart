import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

abstract class DailyClosingReportRepository {
  ResultFuture<DailyClosingReportResponse> fetchDailyClosingReport(DailyCloseReportRequest request);
  ResultFuture<ItemwiseReportResponse> fetchItemWiseDetailsReport(ItemWiseReportRequest request);

}