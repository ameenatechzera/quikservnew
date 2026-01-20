import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/data/datasources/userCreationRemoteDataSource.dart';
import 'package:quikservnew/features/masters/data/models/user_types_model.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';

class UserCreationRepositoryImpl implements UserCreationRepository{

  final UserCreationRemoteDataSource remoteDataSource;

  UserCreationRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<UserTypesModel> fetchUserTypes() async {
    try {
      final result = await remoteDataSource.fetchUserTypes();
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
  ResultFuture<MasterResponseModel> saveUserTypes(SaveUserParameters request) async {
    try {
      final result = await remoteDataSource.saveUserTypes(request);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioError catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

}