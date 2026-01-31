import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/accountledger/domain/repositories/account_ledger_repository.dart';

class SaveAccountLedgerUseCase
    implements UseCaseWithParams<MasterResponseModel, AccountLedgerParams> {
  final AccountLedgerRepository _accountLedgerRepository;

  SaveAccountLedgerUseCase(this._accountLedgerRepository);

  @override
  ResultFuture<MasterResponseModel> call(AccountLedgerParams params) async {
    return _accountLedgerRepository.saveAccountLedger(params);
  }
}
