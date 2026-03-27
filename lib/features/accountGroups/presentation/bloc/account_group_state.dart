part of 'account_group_cubit.dart';

@immutable
sealed class AccountGroupState {}

final class AccountGroupInitial extends AccountGroupState {}

final class SaveAccountGroupInitial extends AccountGroupState {}

final class DeleteAccountGroupInitial extends AccountGroupState {}

final class UpdateAccountGroupInitial extends AccountGroupState {}

final class AccountGroupsLoaded extends AccountGroupState {
  final List<AccountGroups> accountGroups;
  AccountGroupsLoaded({required this.accountGroups});
}

final class SaveAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  SaveAccountGroupCompleted({required this.result});
}

final class AccountGroupsError extends AccountGroupState {
  final String error;
  AccountGroupsError({required this.error});
}

final class SaveAccountGroupsError extends AccountGroupState {
  final String error;
  SaveAccountGroupsError({required this.error});
}

final class DeleteAccountGroupsError extends AccountGroupState {
  final String error;
  DeleteAccountGroupsError({required this.error});
}

final class DeleteAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  DeleteAccountGroupCompleted({required this.result});
}

final class UpdateAccountGroupsError extends AccountGroupState {
  final String error;
  UpdateAccountGroupsError({required this.error});
}

final class UpdateAccountGroupCompleted extends AccountGroupState {
  final MasterResponseModel result;
  UpdateAccountGroupCompleted({required this.result});
}
