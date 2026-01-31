part of 'accountledger_cubit.dart';

sealed class AccountledgerState extends Equatable {
  const AccountledgerState();

  @override
  List<Object> get props => [];
}

final class AccountledgerInitial extends AccountledgerState {}

class AccountledgerLoading extends AccountledgerState {}

class AccountledgerLoaded extends AccountledgerState {
  final FetchAccountLedgerResponseModel accountLedger;

  const AccountledgerLoaded({required this.accountLedger});
}

class AccountledgerError extends AccountledgerState {
  final String error;

  const AccountledgerError({required this.error});
}
