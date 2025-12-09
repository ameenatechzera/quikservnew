import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';

abstract class SettingsRepository {
  ResultFuture<FetchSettingsResponseModel> fetchSettings();
}
