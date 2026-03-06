import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchSalesCountGraphReportUseCase implements UseCaseWithParams<MonthlyGraphReportResult, BarGraphRequest> {

  final SettingsRepository _generalRepository;

  FetchSalesCountGraphReportUseCase(this._generalRepository);

  @override
  ResultFuture<MonthlyGraphReportResult> call(BarGraphRequest request) async => _generalRepository.fetchSalesCountReport(request);

}