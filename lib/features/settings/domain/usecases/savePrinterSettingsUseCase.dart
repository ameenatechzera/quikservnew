

import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/printerSaveResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/savePrinterSettingsRequest.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class SavePrinterSettingsUseCase implements UseCaseWithParams<PrinterSettingsSaveResult, SavePrinterSettingsRequest> {
  final SettingsRepository _homeRepository;

  SavePrinterSettingsUseCase(this._homeRepository);

  @override
  ResultFuture<PrinterSettingsSaveResult> call(SavePrinterSettingsRequest request) async => _homeRepository.savePrinterSettingsToServer(request);
}