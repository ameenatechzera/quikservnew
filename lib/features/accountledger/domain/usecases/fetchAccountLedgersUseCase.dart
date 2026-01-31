import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';

class FetchAccountLedgerUseCase
    implements UseCaseWithoutParams<FetchAccountLedgerResponseModel> {
  final AccountLedgerRepository _accountLedgerRepository;

  FetchAccountLedgerUseCase(this._accountLedgerRepository);

  @override
  ResultFuture<FetchAccountLedgerResponseModel> call() async {
    return _accountLedgerRepository.fetchAccountLedgers();
  }
}
