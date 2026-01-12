import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/data/datasources/salesReport_remote_datasource.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';

class SalesReportRepositoryImpl implements SalesReportRepository {
  final SalesReportRemoteDataSource remoteDataSource;

  SalesReportRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<SalesReportResult> fetchSalesReport(
    FetchReportRequest request,
  ) async {
    try {
      final result = await remoteDataSource.fetchSalesReport(request);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<SalesDetailsByMasterIdResult> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  ) async {
    try {
      final result = await remoteDataSource.fetchSalesDetailsByMasterId(
        request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }

  @override
  ResultFuture<SalesReportResult> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  ) async {
    try {
      final result = await remoteDataSource.fetchSalesReportMasterByDate(
        request,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message.toString()));
    }
  }
}
