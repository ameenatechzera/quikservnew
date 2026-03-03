import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/TokenUpdateResult.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';
import 'package:quikservnew/features/settings/domain/entities/tokenDetailsResult.dart';
import 'package:quikservnew/features/settings/domain/entities/weeklyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/customSalesGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchCurrenSalesTokenUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchCustomSalesAmountGraphUseCase.dart';


import 'package:quikservnew/features/settings/domain/usecases/fetchMonthlyGraphReportUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchSalesCountGraphUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchWeeklyGraphReportUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/save_accountsettings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/updatesalesTokenUseCase.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FetchSettingsUseCase _fetchSettingsUseCase;
  final FetchCurrentSalesTokenUseCase _fetchCurrentSalesTokenUseCase;
  final UpdateSalesTokenUseCase _updateSalesTokenUseCase;
  final SaveAccountSettingsUseCase _saveAccountSettingsUseCase;
  final FetchMonthlyGraphReportUseCase _fetchMonthlyGraphReportUseCase;
  final FetchSalesCountGraphReportUseCase _fetchSalesCountGraphReportUseCase;
  final FetchCustomSalesAmountGraphReportUseCase _fetchCustomSalesAmountGraphReportUseCase;

  SettingsCubit({
    required FetchSettingsUseCase fetchSettingsUseCase,
    required FetchCurrentSalesTokenUseCase fetchCurrentSalesTokenUseCase,
    required UpdateSalesTokenUseCase updateSalesTokenUseCase,
    required SaveAccountSettingsUseCase saveAccountSettingsUseCase,
    required FetchMonthlyGraphReportUseCase fetchMonthlyGraphReportUseCase,
    required FetchSalesCountGraphReportUseCase fetchSalesCountGraphReportUseCase,
    required FetchCustomSalesAmountGraphReportUseCase fetchCustomSalesAmountGraphReportUseCase
  }) : _fetchSettingsUseCase = fetchSettingsUseCase,
       _fetchCurrentSalesTokenUseCase = fetchCurrentSalesTokenUseCase,
       _updateSalesTokenUseCase = updateSalesTokenUseCase,
       _saveAccountSettingsUseCase = saveAccountSettingsUseCase,
        _fetchMonthlyGraphReportUseCase = fetchMonthlyGraphReportUseCase,
        _fetchSalesCountGraphReportUseCase = fetchSalesCountGraphReportUseCase,
        _fetchCustomSalesAmountGraphReportUseCase = fetchCustomSalesAmountGraphReportUseCase,
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

  Future<void> fetchMonthlyGraphFromServer(BarGraphRequest request) async {
    emit(FetchMonthlyGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchMonthlyGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

      response.fold(
            (failure) async {
          log("failure");
          emit(FetchMonthlyGraphError(failure.message));
        },
            (success) {
          emit(FetchMonthlyGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchMonthlyGraphError('An error occurred: $e'));
    }
  }

  Future<void> fetchYearlyGraphFromServer(BarGraphRequest request) async {
    emit(FetchMonthlyGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchMonthlyGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

      response.fold(
            (failure) async {
          log("failure");
          emit(FetchMonthlyGraphError(failure.message));
        },
            (success) {
          emit(FetchYearlyGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchMonthlyGraphError('An error occurred: $e'));
    }
  }
  Future<void> fetchDailyGraphFromServer(BarGraphRequest request) async {
    emit(FetchMonthlyGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchMonthlyGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

      response.fold(
            (failure) async {
          log("failure");
          emit(FetchMonthlyGraphError(failure.message));
        },
            (success) {
          emit(FetchDailyGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchMonthlyGraphError('An error occurred: $e'));
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

  Future<void> fetchSalesCountFromServer(BarGraphRequest request) async {
    emit(FetchSalesCountGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchSalesCountGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

      response.fold(
            (failure) async {
          log("failure");
          emit(FetchSalesCountGraphError(failure.message));
        },
            (success) {
          emit(FetchSalesCountGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchSalesCountGraphError('An error occurred: $e'));
    }
  }

  Future<void> fetchCustomSalesGraphFromServer(CustomSalesGraphRequest request) async {
    emit(FetchCustomSalesGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchCustomSalesAmountGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

      response.fold(
            (failure) async {
          log("failure");
          emit(FetchCustomSalesGraphError(failure.message));
        },
            (success) {
          emit(FetchCustomSalesGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchCustomSalesGraphError('An error occurred: $e'));
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
