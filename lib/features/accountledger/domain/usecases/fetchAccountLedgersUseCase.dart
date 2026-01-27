import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/domain/entities/account_ledger_entity.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';

class FetchAccountLedgerUseCase
    implements UseCaseWithoutParams<AccountLedgerResponse> {
  final AccountLedgerRepository _accountLedgerRepository;

  FetchAccountLedgerUseCase(this._accountLedgerRepository);

  @override
  ResultFuture<AccountLedgerResponse> call() async {
    return _accountLedgerRepository.fetchAccountLedgers();
  }
}