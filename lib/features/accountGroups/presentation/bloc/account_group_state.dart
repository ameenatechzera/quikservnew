part of 'account_group_cubit.dart';

@immutable
sealed class AccountGroupState {}

final class AccountGroupInitial extends AccountGroupState {}
final class SaveAccountGroupInitial extends AccountGroupState {}

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
