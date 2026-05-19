import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/common_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/loyaltyCustomerSaveRequest.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class SaveLoyaltyCustomerUseCase
    implements UseCaseWithParams<CommonResult, LoyaltyCustomerSaveRequest> {
  final SettingsRepository _accountSettingsRepository;

  SaveLoyaltyCustomerUseCase(this._accountSettingsRepository);

  @override
  ResultFuture<CommonResult> call(LoyaltyCustomerSaveRequest params) async {
    return _accountSettingsRepository.saveLoyaltyCustomer(params);
  }
}