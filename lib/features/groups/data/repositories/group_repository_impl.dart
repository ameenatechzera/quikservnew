import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource remoteDataSource;

  GroupsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<FetchGroupResponseModel> fetchGroups() async {
    try {
      final result = await remoteDataSource.fetchGroups();
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
  ResultFuture<MasterResponseModel> addProductGroup(
    AddProductGroupRequestModel params,
  ) async {
    try {
      final result = await remoteDataSource.addProductGroup(params);
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
  ResultFuture<MasterResponseModel> deleteProductGroup(int groupId) async {
    try {
      final result = await remoteDataSource.deleteProductGroup(groupId);
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
  ResultFuture<MasterResponseModel> editProductGroup(
    int groupId,
    EditProductGroupRequestModel params,
  ) async {
    try {
      final result = await remoteDataSource.editProductGroup(groupId, params);
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
