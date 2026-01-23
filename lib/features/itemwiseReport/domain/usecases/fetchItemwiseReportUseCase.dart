import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/repositories/ItemWiseReportRepository.dart';

class FetchItemWiseReportUseCase implements UseCaseWithParams<ItemwiseReportResponse, ItemWiseReportRequest> {

  final ItemWiseReportRepository _itemWiseReportRepository;

  FetchItemWiseReportUseCase(this._itemWiseReportRepository);

  @override
  ResultFuture<ItemwiseReportResponse> call(ItemWiseReportRequest request) async => _itemWiseReportRepository.fetchItemWiseReport(request);
}