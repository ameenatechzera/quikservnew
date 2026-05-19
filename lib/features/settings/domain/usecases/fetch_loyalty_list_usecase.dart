import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/data/models/loyaltylist_model.dart';
import 'package:quikservnew/features/settings/domain/entities/loyaltyListResult.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchLoyaltyListUseCase
    implements UseCaseWithoutParams<LoyaltyCardListResult> {
  final SettingsRepository _settingsRepository;

  FetchLoyaltyListUseCase(this._settingsRepository);

  @override
  ResultFuture<LoyaltyCardListResult> call() async {
    return _settingsRepository.fetchLoyaltyList();
  }
}