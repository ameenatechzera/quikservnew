import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';

class UpdateAccountLedgerUseCase {
  final AccountLedgerRepository _accountLedgerRepository;

  UpdateAccountLedgerUseCase(this._accountLedgerRepository);

  ResultFuture<MasterResponseModel> call(
    int ledgerId,
    AccountLedgerParams request,
  ) async {
    return _accountLedgerRepository.updateAccountLedger(ledgerId, request);
  }
}
