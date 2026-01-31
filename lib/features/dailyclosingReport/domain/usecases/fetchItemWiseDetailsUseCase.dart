import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/repositories/dailyClosingReportRepository.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

class FetchItemWiseDetailsUseCase implements UseCaseWithParams<ItemwiseReportResponse, ItemWiseReportRequest> {

  final DailyClosingReportRepository _itemWiseReportRepository;

  FetchItemWiseDetailsUseCase(this._itemWiseReportRepository);

  @override
  ResultFuture<ItemwiseReportResponse> call(ItemWiseReportRequest request) async => _itemWiseReportRepository.fetchItemWiseDetailsReport(request);
}