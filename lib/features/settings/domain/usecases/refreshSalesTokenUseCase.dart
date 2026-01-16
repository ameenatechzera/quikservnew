

import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/commonResult.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class ResetSlesTokenUseCase implements UseCaseWithoutParams<CommonResult> {
  final SettingsRepository _homeRepository;

  ResetSlesTokenUseCase(this._homeRepository);

  @override
  ResultFuture<CommonResult> call() async => _homeRepository.refreshSalesToken();
}