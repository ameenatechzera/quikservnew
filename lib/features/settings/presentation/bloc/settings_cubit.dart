import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FetchSettingsUseCase _fetchSettingsUseCase;

  SettingsCubit({required FetchSettingsUseCase fetchSettingsUseCase})
    : _fetchSettingsUseCase = fetchSettingsUseCase,
      super(SettingsInitial());

  Future<void> fetchSettings() async {
    emit(SettingsLoading());

    final response = await _fetchSettingsUseCase();

    response.fold(
      (failure) => emit(SettingsError(error: failure.message)),
      (response) => emit(SettingsLoaded(settings: response)),
    );
  }
}
