import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/fetch_account_ledger_usecase.dart';

part 'accountledger_state.dart';

class AccountledgerCubit extends Cubit<AccountledgerState> {
  final FetchAccountLedgerUseCase _fetchAccountLedgerUseCase;
  AccountledgerCubit({
    required FetchAccountLedgerUseCase fetchAccountLedgerUseCase,
  }) : _fetchAccountLedgerUseCase = fetchAccountLedgerUseCase,
       super(AccountledgerInitial());

  /// 🔹 Fetch account ledger list
  Future<void> fetchAccountLedger() async {
    emit(AccountledgerLoading());

    final response = await _fetchAccountLedgerUseCase();

    response.fold(
      (failure) => emit(AccountledgerError(error: failure.message)),
      (response) => emit(AccountledgerLoaded(accountLedger: response)),
    );
  }
}
