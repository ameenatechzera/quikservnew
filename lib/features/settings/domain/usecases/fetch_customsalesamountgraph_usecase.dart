import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchCustomSalesAmountGraphReportUseCase
    implements
        UseCaseWithParams<MonthlyGraphReportResult, CustomSalesGraphRequest> {
  final SettingsRepository _generalRepository;

  FetchCustomSalesAmountGraphReportUseCase(this._generalRepository);

  @override
  ResultFuture<MonthlyGraphReportResult> call(
    CustomSalesGraphRequest request,
  ) async => _generalRepository.fetchCustomSalesGraph(request);
}
