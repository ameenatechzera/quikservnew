import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/failure.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/data/datasources/payment_remote_data_source.dart';
import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/paymentVoucherRequest.dart';
import 'package:quikservnew/features/paymentVoucher/domain/repositories/payment_repository.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  PaymentRepositoryImpl({required this.remoteDataSource});
  @override
  ResultFuture<MasterResponseModel> savePaymentVoucher(PaymentVoucherRequest request) async {
    try {
      final result = await remoteDataSource.savePaymentVoucher(request);
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