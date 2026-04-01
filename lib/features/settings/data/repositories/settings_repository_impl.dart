import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/common_result.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/entities/printer_save_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_details_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_update_result.dart';
import 'package:quikservnew/features/settings/domain/entities/weekly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/sales_tokenupdate_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/save_printersettings_request.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<FetchSettingsResponseModel> fetchSettings() async {
    try {
      final result = await remoteDataSource.fetchSettings();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<CommonResult> refreshSalesToken() async {
    try {
      final result = await remoteDataSource.refreshSalesToken();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<TokenDetailsResult> fetchCurrentSalesTokenDetails() async {
    try {
      final result = await remoteDataSource.fetchCurrentSalesToken();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<TokenUpdateResult> updateSalesTokenToServer(
    UpdateSalesTokenRequest updateSalesTokenRequest,
  ) async {
    try {
      final result = await remoteDataSource.updateSalesTokenToServer(
        updateSalesTokenRequest,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> saveAccountSettings(
    AccountSettingsParams params,
  ) async {
    try {
      final result = await remoteDataSource.saveAccountSettings(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<MonthlyGraphReportResult> fetchMonthlyGraphReport(
    BarGraphRequest request,
  ) async {
    try {
      final result = await remoteDataSource.fetchMonthlyGraphReport(request);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<WeeklyGraphReportResult> fetchWeeklyGraphReport(
    BarGraphRequest request,
  ) async {
    try {
      final result = await remoteDataSource.fetchWeeklyGraphReport(request);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<MonthlyGraphReportResult> fetchSalesCountReport(
    BarGraphRequest params,
  ) async {
    try {
      final result = await remoteDataSource.fetchSalesCountGraph(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<MonthlyGraphReportResult> fetchCustomSalesGraph(
    CustomSalesGraphRequest params,
  ) async {
    try {
      final result = await remoteDataSource.fetchCustomSalesGraph(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<PrinterSettingsSaveResult> savePrinterSettingsToServer(
    SavePrinterSettingsRequest savePrinterSettingsRequest,
  ) async {
    try {
      final result = await remoteDataSource.savePrinterSettings(
        savePrinterSettingsRequest,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }
}
