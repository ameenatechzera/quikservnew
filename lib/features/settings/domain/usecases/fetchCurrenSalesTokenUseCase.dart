

import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/tokenDetailsResult.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchCurrentSalesTokenUseCase implements UseCaseWithoutParams<TokenDetailsResult> {

  final SettingsRepository _generalRepository;

  FetchCurrentSalesTokenUseCase(this._generalRepository);

  @override
  ResultFuture<TokenDetailsResult> call() async => _generalRepository.fetchCurrentSalesTokenDetails();

}