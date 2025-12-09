import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchSettingsUseCase
    implements UseCaseWithoutParams<FetchSettingsResponseModel> {
  final SettingsRepository _settingsRepository;

  FetchSettingsUseCase(this._settingsRepository);

  @override
  ResultFuture<FetchSettingsResponseModel> call() async {
    return _settingsRepository.fetchSettings();
  }
}
