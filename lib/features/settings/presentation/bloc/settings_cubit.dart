import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/TokenUpdateResult.dart';
import 'package:quikservnew/features/settings/domain/entities/tokenDetailsResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchCurrenSalesTokenUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/save_accountsettings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/updatesalesTokenUseCase.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FetchSettingsUseCase _fetchSettingsUseCase;
  final FetchCurrentSalesTokenUseCase _fetchCurrentSalesTokenUseCase;
  final UpdateSalesTokenUseCase _updateSalesTokenUseCase;
  final SaveAccountSettingsUseCase _saveAccountSettingsUseCase;

  SettingsCubit({
    required FetchSettingsUseCase fetchSettingsUseCase,
    required FetchCurrentSalesTokenUseCase fetchCurrentSalesTokenUseCase,
    required UpdateSalesTokenUseCase updateSalesTokenUseCase,
    required SaveAccountSettingsUseCase saveAccountSettingsUseCase,
  }) : _fetchSettingsUseCase = fetchSettingsUseCase,
       _fetchCurrentSalesTokenUseCase = fetchCurrentSalesTokenUseCase,
       _updateSalesTokenUseCase = updateSalesTokenUseCase,
       _saveAccountSettingsUseCase = saveAccountSettingsUseCase,
       super(SettingsInitial());

  Future<void> fetchSettings() async {
    emit(SettingsLoading());

    final response = await _fetchSettingsUseCase();

    response.fold(
      (failure) => emit(SettingsError(error: failure.message)),
      (response) => emit(SettingsLoaded(settings: response)),
    );
  }

  Future<void> printSelection(String st_PrintType) async {
    emit(PrintTypeSelected(st_PrintType));
  }

  Future<void> fetchSalesTokenFromServer() async {
    emit(FetchSalesTokenLoading());
    try {
      print('reached cubit');
      final response = await _fetchCurrentSalesTokenUseCase();
      log(response.toString(), name: 'result_settings');

      response.fold(
        (failure) async {
          log("failure");
          emit(FetchSalesTokenError(failure.message));
        },
        (success) {
          log(success.message);

          emit(FetchSalesTokenSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchSalesTokenError('An error occurred: $e'));
    }
  }

  Future<void> updateSalesTokenFromServer(
    UpdateSalesTokenRequest updateTokenRequest,
  ) async {
    emit(UpdateSalesTokenLoading());
    try {
      print('reached cubit');
      final response = await _updateSalesTokenUseCase(updateTokenRequest);
      log(response.toString(), name: 'result_settings');

      response.fold(
        (failure) async {
          log("failure");
          emit(UpdateSalesTokenError(failure.message));
        },
        (success) {
          log(success.message);

          emit(UpdateSalesTokenSuccess(success));
        },
      );
    } catch (e) {
      emit(UpdateSalesTokenError('An error occurred: $e'));
    }
  }

  Future<void> saveAccountSettings(AccountSettingsParams params) async {
    emit(SaveAccountSettingsLoading());

    try {
      final response = await _saveAccountSettingsUseCase(params);
      // // 🔹 Save selected ledger IDs in SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setInt('cashLedgerId', params.cashLedgerId);
      // await prefs.setInt('cardLedgerId', params.cardLedgerId);
      // await prefs.setInt('bankLedgerId', params.bankLedgerId);
      log(response.toString(), name: 'save_account_settings');

      response.fold(
        (failure) {
          emit(SaveAccountSettingsError(error: failure.message));
        },
        (success) {
          emit(SaveAccountSettingsSuccess(success));
        },
      );
    } catch (e) {
      emit(SaveAccountSettingsError(error: 'An error occurred: $e'));
    }
  }

  // /// 🔹 Optional: Load saved ledger IDs
  // Future<Map<String, int>> loadSavedLedgers() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return {
  //     'cashLedgerId': prefs.getInt('cashLedgerId') ?? 0,
  //     'cardLedgerId': prefs.getInt('cardLedgerId') ?? 0,
  //     'bankLedgerId': prefs.getInt('bankLedgerId') ?? 0,
  //   };
  // }
}
