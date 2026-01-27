import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/domain/entities/account_ledger_entity.dart';

abstract class AccountLedgerRepository {
  ResultFuture<AccountLedgerResponse> fetchAccountLedgers();

// ResultFuture<MasterResponseModel> saveAccountGroup(
//     SaveAccountGroupRequest params,
//     );
//
// ResultFuture<MasterResponseModel> deleteAccountGroup(
//     DeleteAccountGroupRequest request,
//     );
//
// ResultFuture<MasterResponseModel> updateAccountGroup(
//     UpdateAccountGroupRequest request,
//     );
}