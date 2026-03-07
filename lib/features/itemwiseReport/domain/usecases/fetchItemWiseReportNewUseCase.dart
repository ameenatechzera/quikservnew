import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwiseReportNew.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/repositories/ItemWiseReportRepository.dart';

class FetchItemWiseReportNewUseCase implements UseCaseWithParams<ItemWiseReportResult, ItemWiseReportRequest> {

  final ItemWiseReportRepository _itemWiseReportRepository;

  FetchItemWiseReportNewUseCase(this._itemWiseReportRepository);

  @override
  ResultFuture<ItemWiseReportResult> call(ItemWiseReportRequest request) async => _itemWiseReportRepository.fetchItemWiseReportNew(request);
}