import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/datasources/account_ledger_datasources.dart';
import 'package:quikservnew/features/accountledger/domain/entities/account_ledger_entity.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';

abstract class AccountLedgerRepositoryImpl implements AccountLedgerRepository {

  final AccountLedgerRemoteDataSource remoteDataSource;
  AccountLedgerRepositoryImpl({required this.remoteDataSource});
  ResultFuture<AccountLedgerResponse> fetchAccountLedgers() async {
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


}