import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/vat/data/datasources/vat_remote_data_source.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';

class VatRepositoryImpl implements VatRepository {
  final VatRemoteDataSource remoteDataSource;

  VatRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<FetchVatResponseModel> fetchVat() async {
    try {
      final result = await remoteDataSource.fetchVat();
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
