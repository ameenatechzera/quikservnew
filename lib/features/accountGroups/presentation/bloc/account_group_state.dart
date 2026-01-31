part of 'account_group_cubit.dart';

@immutable
sealed class AccountGroupState {}

final class AccountGroupInitial extends AccountGroupState {}

final class SaveAccountGroupInitial extends AccountGroupState {}

final class DeleteAccountGroupInitial extends AccountGroupState {}

final class UpdateAccountGroupInitial extends AccountGroupState {}

final class AccountGroupsLoaded extends AccountGroupState {
  final List<AccountGroups> account_groups;
  AccountGroupsLoaded({required this.account_groups});

  @override
  List<Object> get props => [account_groups];
}

final class SaveAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  SaveAccountGroupCompleted({required this.result});

  @override
  List<Object> get props => [result];
}

final class AccountGroupsError extends AccountGroupState {
  final String error;
  AccountGroupsError({required this.error});

  @override
  List<Object> get props => [error];
}

final class SaveAccountGroupsError extends AccountGroupState {
  final String error;
  SaveAccountGroupsError({required this.error});

  @override
  List<Object> get props => [error];
}

final class DeleteAccountGroupsError extends AccountGroupState {
  final String error;
  DeleteAccountGroupsError({required this.error});

  @override
  List<Object> get props => [error];
}

final class DeleteAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  DeleteAccountGroupCompleted({required this.result});

  @override
  List<Object> get props => [result];
}

final class UpdateAccountGroupsError extends AccountGroupState {
  final String error;
  UpdateAccountGroupsError({required this.error});

  @override
  List<Object> get props => [error];
}

final class UpdateAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  UpdateAccountGroupCompleted({required this.result});

  @override
  List<Object> get props => [result];
}
