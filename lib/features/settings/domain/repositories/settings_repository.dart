import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/TokenUpdateResult.dart';
import 'package:quikservnew/features/settings/domain/entities/commonResult.dart';
import 'package:quikservnew/features/settings/domain/entities/tokenDetailsResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';

abstract class SettingsRepository {
  ResultFuture<FetchSettingsResponseModel> fetchSettings();
  ResultFuture<CommonResult> refreshSalesToken();
  ResultFuture<TokenDetailsResult> fetchCurrentSalesTokenDetails();
  ResultFuture<TokenUpdateResult> updateSalesTokenToServer(UpdateSalesTokenRequest updateSalesTokenRequest);
}
