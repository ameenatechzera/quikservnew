import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/data/datasources/dailyCloseReport_remote_datasource.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/repositories/dailyClosingReportRepository.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

class DailyclosereportRepositoryImpl  implements DailyClosingReportRepository{
  final DailyClosingReportRemoteDataSource remoteDataSource;
  DailyclosereportRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<DailyClosingReportResponse> fetchDailyClosingReport(DailyCloseReportRequest request)
    async {
      try {
        final result = await remoteDataSource.fetchDailyClosingReport(request);
        return Right(result);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.statusMessage));
      } on DioException catch (failure) {
        return Left(ServerFailure(failure.message.toString()));
      }
    }

  @override
  ResultFuture<ItemwiseReportResponse> fetchItemWiseDetailsReport(ItemWiseReportRequest request)
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