

import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/TokenUpdateResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class UpdateSalesTokenUseCase implements UseCaseWithParams<TokenUpdateResult, UpdateSalesTokenRequest> {
  final SettingsRepository _homeRepository;

  UpdateSalesTokenUseCase(this._homeRepository);

  @override
  ResultFuture<TokenUpdateResult> call(UpdateSalesTokenRequest request) async => _homeRepository.updateSalesTokenToServer(request);
}