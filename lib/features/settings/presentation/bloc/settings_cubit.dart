import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/printer_save_result.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/entities/sales_count_graph_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_details_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_update_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/sales_tokenupdate_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/save_printersettings_request.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_currentsalestoken_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_customsalesamountgraph_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_monthlygraphreport_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/savePrinterSettingsUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/save_accountsettings_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/updatesalesTokenUseCase.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FetchSettingsUseCase _fetchSettingsUseCase;
  final FetchCurrentSalesTokenUseCase _fetchCurrentSalesTokenUseCase;
  final UpdateSalesTokenUseCase _updateSalesTokenUseCase;
  final SaveAccountSettingsUseCase _saveAccountSettingsUseCase;
  final FetchMonthlyGraphReportUseCase _fetchMonthlyGraphReportUseCase;
  //final FetchSalesCountGraphReportUseCase _fetchSalesCountGraphReportUseCase;
  final FetchCustomSalesAmountGraphReportUseCase
  _fetchCustomSalesAmountGraphReportUseCase;
  final SavePrinterSettingsUseCase _savePrinterSettingsUseCase;

  SettingsCubit({
    required FetchSettingsUseCase fetchSettingsUseCase,
    required FetchCurrentSalesTokenUseCase fetchCurrentSalesTokenUseCase,
    required UpdateSalesTokenUseCase updateSalesTokenUseCase,
    required SaveAccountSettingsUseCase saveAccountSettingsUseCase,
    required FetchMonthlyGraphReportUseCase fetchMonthlyGraphReportUseCase,
    // required FetchSalesCountGraphReportUseCase
    // fetchSalesCountGraphReportUseCase,
    required FetchCustomSalesAmountGraphReportUseCase
    fetchCustomSalesAmountGraphReportUseCase,
    required SavePrinterSettingsUseCase savePrinterSettingsUseCase,
  }) : _fetchSettingsUseCase = fetchSettingsUseCase,
       _fetchCurrentSalesTokenUseCase = fetchCurrentSalesTokenUseCase,
       _updateSalesTokenUseCase = updateSalesTokenUseCase,
       _saveAccountSettingsUseCase = saveAccountSettingsUseCase,
       _fetchMonthlyGraphReportUseCase = fetchMonthlyGraphReportUseCase,
       // _fetchSalesCountGraphReportUseCase = fetchSalesCountGraphReportUseCase,
       _fetchCustomSalesAmountGraphReportUseCase =
           fetchCustomSalesAmountGraphReportUseCase,
       _savePrinterSettingsUseCase = savePrinterSettingsUseCase,
       super(SettingsInitial());

  Future<void> fetchSettings() async {
    emit(SettingsLoading());

    final response = await _fetchSettingsUseCase();

    response.fold(
      (failure) => emit(SettingsError(error: failure.message)),
      (response) => emit(SettingsLoaded(settings: response)),
    );
  }

  Future<void> savePrinterSettingsToServer(
    SavePrinterSettingsRequest savePrinterSettingsRequest,
  ) async {
    emit(SavePrinterSettingsInitial());
    try {
      final response = await _savePrinterSettingsUseCase(
        savePrinterSettingsRequest,
      );
      response.fold(
        (failure) {
          emit(SavePrinterSettingsError(failure.message));
        },
        (success) {
          emit(PrinterSettingsSaved(success));
        },
      );
    } catch (e) {
      emit(SavePrinterSettingsError('An error occurred: $e'));
    }
  }

  Future<void> printSelection(String st_PrintType) async {
    emit(PrintTypeSelected(st_PrintType));
  }

  Future<void> fetchSalesTokenFromServer() async {
    emit(FetchSalesTokenLoading());
    try {
      final response = await _fetchCurrentSalesTokenUseCase();
      response.fold(
        (failure) async {
          emit(FetchSalesTokenError(failure.message));
        },
        (success) {
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
      final response = await _fetchMonthlyGraphReportUseCase(request);
      response.fold(
        (failure) async {
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
      final response = await _fetchMonthlyGraphReportUseCase(request);
      response.fold(
        (failure) async {
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
      final response = await _fetchMonthlyGraphReportUseCase(request);
      response.fold(
        (failure) async {
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
      final response = await _updateSalesTokenUseCase(updateTokenRequest);
      response.fold(
        (failure) async {
          log("failure");
          emit(UpdateSalesTokenError(failure.message));
        },
        (success) {
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

  Future<void> fetchCustomSalesGraphFromServer(
    CustomSalesGraphRequest request,
  ) async {
    emit(FetchCustomSalesGraphLoading());
    try {
      final response = await _fetchCustomSalesAmountGraphReportUseCase(request);
      response.fold(
        (failure) async {
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
}
