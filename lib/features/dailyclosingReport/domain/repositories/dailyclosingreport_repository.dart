import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyclosingreport_result.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyclosingreport_request.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';

abstract class DailyClosingReportRepository {
  ResultFuture<DailyClosingReportResponse> fetchDailyClosingReport(
    DailyCloseReportRequest request,
  );
  ResultFuture<ItemwiseReportResponse> fetchItemWiseDetailsReport(
    ItemWiseReportRequest request,
  );
}
