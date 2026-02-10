import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/datasources/account_ledger_remote_datasource.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_bankaccountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/entities/accLedgerResponse.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/fetch_backaccountledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class AccountLedgerRepositoryImpl implements AccountLedgerRepository {
  final AccountLedgerRemoteDataSource remoteDataSource;

  AccountLedgerRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<FetchAccountLedgerResponseModel> fetchAccountLedgers() async {
    try {
      final result = await remoteDataSource.fetchAccountLedgers();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<MasterResponseModel> deleteAccountLedger(int ledgerId) async {
    try {
      final result = await remoteDataSource.deleteAccountLedger(ledgerId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<AccLedgerResponseModel> saveAccountLedger(
    AccountLedgerParams params,
  ) async {
    try {
      final result = await remoteDataSource.saveAccountLedger(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<MasterResponseModel> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  ) async {
    try {
      final result = await remoteDataSource.updateAccountLedger(
        ledgerId,
        params,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  ResultFuture<FetchBankAccountLedgerResponseModel> fetchBankAccountLedgers(
    FetchBankAccountLedgerParams params,
  ) async {
    try {
      final result = await remoteDataSource.fetchBankAccountLedger(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }
}
