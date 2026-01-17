import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/data/datasources/units_remote_datasource.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';
import 'package:quikservnew/features/units/domain/parameters/save_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/parameters/update_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  final UnitsRemoteDataSource remoteDataSource;

  UnitsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<FetchUnitResponseModel> fetchUnits() async {
    try {
      final result = await remoteDataSource.fetchUnits();
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
  ResultFuture<MasterResponseModel> saveUnitToSServer(
    SaveUnitRequestModel request,
  ) async {
    try {
      final result = await remoteDataSource.saveUnitToServer(request);
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
  ResultFuture<MasterResponseModel> deleteUnitFromServer(int unitId) async {
    try {
      final result = await remoteDataSource.deleteUnitFromServer(unitId);
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
  ResultFuture<MasterResponseModel> updateUnitFromServer(
    int unitId,
    EditUnitRequestModel request,
  ) async {
    try {
      final result = await remoteDataSource.editUnitOnServer(unitId, request);
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
