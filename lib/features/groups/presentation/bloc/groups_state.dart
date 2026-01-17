part of 'groups_cubit.dart';

sealed class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

final class GroupsInitial extends GroupsState {}

final class GroupsLoading extends GroupsState {}

final class GroupsLoaded extends GroupsState {
  final FetchGroupResponseModel groups;
  const GroupsLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

final class GroupsError extends GroupsState {
  final String error;
  const GroupsError({required this.error});

  @override
  List<Object> get props => [error];
}

/// Add Product Group States
class GroupAddLoading extends GroupsState {}

class GroupAdded extends GroupsState {
  final MasterResponseModel response;

  const GroupAdded({required this.response});
}

class GroupAddError extends GroupsState {
  final String error;

  const GroupAddError({required this.error});
}

class GroupDeleteLoading extends GroupsState {}

class GroupDeleted extends GroupsState {
  final MasterResponseModel response;
  const GroupDeleted({required this.response});
}

class GroupDeleteError extends GroupsState {
  final String error;
  const GroupDeleteError({required this.error});
}

/// 🔹 Edit Group
class GroupEditLoading extends GroupsState {}

class GroupEdited extends GroupsState {
  final MasterResponseModel response;

  const GroupEdited({required this.response});
}

class GroupEditError extends GroupsState {
  final String error;

  const GroupEditError({required this.error});
}
