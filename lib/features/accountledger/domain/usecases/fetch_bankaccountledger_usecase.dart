import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_bankaccountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/fetch_backaccountledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';

class FetchBankAccountLedgerUseCase
    implements
        UseCaseWithParams<
          FetchBankAccountLedgerResponseModel,
          FetchBankAccountLedgerParams
        > {
  final AccountLedgerRepository _accountLedgerRepository;

  FetchBankAccountLedgerUseCase(this._accountLedgerRepository);

  @override
  ResultFuture<FetchBankAccountLedgerResponseModel> call(
    FetchBankAccountLedgerParams params,
  ) async {
    return _accountLedgerRepository.fetchBankAccountLedgers(params);
  }
}
