import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';

abstract class AccountLedgerRepository {
  ResultFuture<FetchLedgerResponseModel> fetchAccountLedger();
}
