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
