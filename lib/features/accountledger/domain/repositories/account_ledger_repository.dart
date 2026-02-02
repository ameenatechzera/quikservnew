import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_bankaccountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/fetch_backaccountledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

abstract class AccountLedgerRepository {
  ResultFuture<FetchAccountLedgerResponseModel> fetchAccountLedgers();

  ResultFuture<MasterResponseModel> deleteAccountLedger(int ledgerId);
  ResultFuture<MasterResponseModel> saveAccountLedger(
    AccountLedgerParams params,
  );

  ResultFuture<MasterResponseModel> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  );
  ResultFuture<FetchBankAccountLedgerResponseModel> fetchBankAccountLedgers(
    FetchBankAccountLedgerParams params,
  );
}
