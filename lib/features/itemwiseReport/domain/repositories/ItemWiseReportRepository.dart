import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';


abstract class ItemWiseReportRepository {
  ResultFuture<ItemwiseReportResponse> fetchItemWiseReport(ItemWiseReportRequest request);

}