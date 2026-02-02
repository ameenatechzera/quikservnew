import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class SaveAccountSettingsUseCase
    implements UseCaseWithParams<MasterResponseModel, AccountSettingsParams> {
  final SettingsRepository _accountSettingsRepository;

  SaveAccountSettingsUseCase(this._accountSettingsRepository);

  @override
  ResultFuture<MasterResponseModel> call(AccountSettingsParams params) async {
    return _accountSettingsRepository.saveAccountSettings(params);
  }
}
