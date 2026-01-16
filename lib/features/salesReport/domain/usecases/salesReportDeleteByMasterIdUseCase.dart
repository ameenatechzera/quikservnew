import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/delete_salesparameter.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';

class DeleteSalesFromServerUseCase implements UseCaseWithParams<void, SalesDeleteByMasterIdRequest> {
  final SalesReportRepository _homeRepository;

  DeleteSalesFromServerUseCase(this._homeRepository);

  @override
  ResultFuture<void> call(SalesDeleteByMasterIdRequest salesDeleteRequest) async => _homeRepository.deleteSalesFromServer(salesDeleteRequest);
}