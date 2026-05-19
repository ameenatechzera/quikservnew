import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/domain/entities/loyaltyCardSaveResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/loyaltyCardSaveRequest.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class SaveLoyaltyCardUseCase
    implements UseCaseWithParams<LoyaltyCardSaveResult, LoyaltyCardSaveRequest> {
  final SettingsRepository _accountSettingsRepository;

  SaveLoyaltyCardUseCase(this._accountSettingsRepository);

  @override
  ResultFuture<LoyaltyCardSaveResult> call(LoyaltyCardSaveRequest params) async {
    return _accountSettingsRepository.saveLoyaltyCard(params);
  }
}