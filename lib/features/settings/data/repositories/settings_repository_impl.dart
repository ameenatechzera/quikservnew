import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/TokenUpdateResult.dart';
import 'package:quikservnew/features/settings/domain/entities/commonResult.dart';
import 'package:quikservnew/features/settings/domain/entities/tokenDetailsResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';
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
      print('📊 API Response: ${result.toJson()}');
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
      print('📊 API Response: ${result.toJson()}');
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
      print('📊 API Response: ${result.toJson()}');
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }
}
