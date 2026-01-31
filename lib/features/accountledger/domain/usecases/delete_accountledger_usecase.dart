import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class DeleteAccountLedgerUseCase
    implements UseCaseWithParams<MasterResponseModel, int> {
  final AccountLedgerRepository _accountLedgerRepository;

  DeleteAccountLedgerUseCase(this._accountLedgerRepository);

  @override
  ResultFuture<MasterResponseModel> call(int ledgerId) async {
    return _accountLedgerRepository.deleteAccountLedger(ledgerId);
  }
}
