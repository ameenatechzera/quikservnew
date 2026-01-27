import 'package:dio/dio.dart';
import 'package:quikservnew/features/accountledger/domain/entities/account_ledger_entity.dart';

abstract class AccountLedgerRemoteDataSource {
  Future<AccountLedgerResponse> fetchAccountLedgers();

}
class AccountLedgerRemoteDataSourceImpl implements AccountLedgerRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<AccountLedgerResponse> fetchAccountLedgers() {
    // TODO: implement fetchAccountLedgers
    throw UnimplementedError();
  }
}