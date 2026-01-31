import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/delete_accountledger_usecase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/fetchAccountLedgersUseCase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/save_account_ledger_usecase.dart';
import 'package:quikservnew/features/accountledger/domain/usecases/update_ledger_usecase.dart';

part 'accountledger_state.dart';

class AccountledgerCubit extends Cubit<AccountledgerState> {
  final FetchAccountLedgerUseCase _fetchAccountLedgerUseCase;
  final DeleteAccountLedgerUseCase _deleteAccountLedgerUseCase;
  final SaveAccountLedgerUseCase _saveAccountLedgerUseCase;
  final UpdateAccountLedgerUseCase _updateAccountLedgerUseCase;
  AccountledgerCubit({
    required FetchAccountLedgerUseCase fetchAccountLedgerUseCase,
    required DeleteAccountLedgerUseCase deleteAccountLedgerUseCase,
    required SaveAccountLedgerUseCase saveAccountLedgerUseCase,
    required UpdateAccountLedgerUseCase updateAccountLedgerUseCase,
  }) : _fetchAccountLedgerUseCase = fetchAccountLedgerUseCase,
       _deleteAccountLedgerUseCase = deleteAccountLedgerUseCase,
       _saveAccountLedgerUseCase = saveAccountLedgerUseCase,
       _updateAccountLedgerUseCase = updateAccountLedgerUseCase,
       super(AccountledgerInitial()) {
    debugPrint("🔥 update usecase = $_updateAccountLedgerUseCase");
    debugPrint("🔥 save usecase = $_saveAccountLedgerUseCase");
    debugPrint("🔥 update usecase = $_updateAccountLedgerUseCase");
  }

  /// 🔹 Fetch account ledger list
  Future<void> fetchAccountLedger() async {
    emit(AccountledgerLoading());

    final response = await _fetchAccountLedgerUseCase();

    response.fold(
      (failure) => emit(AccountledgerError(error: failure.message)),
      (response) => emit(AccountledgerLoaded(accountLedger: response)),
    );
  }

  /// 🔹 Delete account ledger
  Future<void> deleteAccountLedger(int ledgerId) async {
    emit(AccountledgerLoading());

    final response = await _deleteAccountLedgerUseCase(ledgerId);

    response.fold(
      (failure) => emit(AccountledgerError(error: failure.message)),
      (_) async {
        // 🔁 Refresh list after delete
        await fetchAccountLedger();
      },
    );
  }

  /// 🔹 Save account ledger
  Future<void> saveAccountLedger(AccountLedgerParams params) async {
    emit(AccountledgerLoading());

    final response = await _saveAccountLedgerUseCase(params);

    response.fold(
      (failure) => emit(AccountledgerError(error: failure.message)),
      (_) async {
        await fetchAccountLedger();
      },
    );
  }

  /// 🔹 Update account ledger
  Future<void> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  ) async {
    emit(AccountledgerLoading());

    final response = await _updateAccountLedgerUseCase(ledgerId, params);

    response.fold(
      (failure) => emit(AccountledgerError(error: failure.message)),
      (_) async {
        await fetchAccountLedger();
      },
    );
  }
}
