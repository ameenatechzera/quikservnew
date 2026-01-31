import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/itemwiseReport/data/datasources/itemwiseReport_remote_datasource.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/repositories/ItemWiseReportRepository.dart';

class ItemWiseReportRepositoryImpl implements ItemWiseReportRepository{
  final ItemWiseReportRemoteDataSource remoteDataSource;
  ItemWiseReportRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<ItemwiseReportResponse> fetchItemWiseReport(ItemWiseReportRequest request)
    async {
      try {
        final result = await remoteDataSource.fetchItemWiseReport(request);
        return Right(result);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.statusMessage));
      } on DioException catch (failure) {
        return Left(ServerFailure(failure.message.toString()));
      }
    }

}