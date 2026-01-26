import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/data/datasources/accountGroup_remote_datasources.dart';
import 'package:quikservnew/features/accountGroups/data/models/accountGroupModel.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class AccountGroupRepositoryImpl implements AccountGroupRepository{
  final AccountGroupsRemoteDataSource remoteDataSource;
  AccountGroupRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<AccountGroupResponse> fetchAccountGroups() async {
    try {
      final result = await remoteDataSource.fetchAccountGroups();
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
  ResultFuture<MasterResponseModel> saveAccountGroup(SaveAccountGroupRequest request) async {
    try {
      final result = await remoteDataSource.saveAccountGroups(request);
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