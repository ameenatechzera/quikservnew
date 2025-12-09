import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/usecases/fetch_groups_usecase.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final FetchGroupsUseCase _fetchGroupsUseCase;

  GroupsCubit({required FetchGroupsUseCase fetchGroupsUseCase})
    : _fetchGroupsUseCase = fetchGroupsUseCase,
      super(GroupsInitial());

  Future<void> fetchGroups() async {
    emit(GroupsLoading());

    final response = await _fetchGroupsUseCase();

    response.fold(
      (failure) => emit(GroupsError(error: failure.message)),
      (response) => emit(GroupsLoaded(groups: response)),
    );
  }
}
