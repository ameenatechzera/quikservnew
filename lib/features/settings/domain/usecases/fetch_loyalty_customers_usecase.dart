import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/loyalty_customer_entity.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchLoyaltyCustomersUseCase
    implements UseCaseWithoutParams<LoyaltyCustomerListResult> {
  final SettingsRepository _settingsRepository;

  FetchLoyaltyCustomersUseCase(this._settingsRepository);

  @override
  ResultFuture<LoyaltyCustomerListResult> call() async {
    return _settingsRepository.fetchLoyaltyCustomerList();
  }
}