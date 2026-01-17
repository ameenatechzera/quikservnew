import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/groups/domain/usecases/add_product_groups_usecase.dart';
import 'package:quikservnew/features/groups/domain/usecases/delete_productgroupfromserver_usecase.dart';
import 'package:quikservnew/features/groups/domain/usecases/fetch_groups_usecase.dart';
import 'package:quikservnew/features/groups/domain/usecases/update_productgroups_usecase.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final FetchGroupsUseCase _fetchGroupsUseCase;
  final AddProductGroupUseCase _addProductGroupUseCase;
  final DeleteProductGroupUseCase _deleteProductGroupUseCase;
  final EditProductGroupUseCase _editProductGroupUseCase;
  GroupsCubit({
    required FetchGroupsUseCase fetchGroupsUseCase,
    required AddProductGroupUseCase addProductGroupUseCase,
    required DeleteProductGroupUseCase deleteProductGroupUseCase,
    required EditProductGroupUseCase editProductGroupUseCase,
  }) : _fetchGroupsUseCase = fetchGroupsUseCase,
       _addProductGroupUseCase = addProductGroupUseCase,
       _deleteProductGroupUseCase = deleteProductGroupUseCase,
       _editProductGroupUseCase = editProductGroupUseCase,
       super(GroupsInitial());

  Future<void> fetchGroups() async {
    emit(GroupsLoading());

    final response = await _fetchGroupsUseCase();

    response.fold(
      (failure) => emit(GroupsError(error: failure.message)),
      (response) => emit(GroupsLoaded(groups: response)),
    );
  }

  /// 🔹 Add a new product group
  Future<void> addProductGroup(AddProductGroupRequestModel request) async {
    emit(GroupAddLoading());

    final response = await _addProductGroupUseCase(request);

    response.fold((failure) => emit(GroupAddError(error: failure.message)), (
      response,
    ) {
      emit(GroupAdded(response: response));
      fetchGroups();
    });
  }

  /// 🔹 Delete a product group
  Future<void> deleteProductGroup(int groupId) async {
    emit(GroupDeleteLoading());

    final response = await _deleteProductGroupUseCase(groupId);

    response.fold((failure) => emit(GroupDeleteError(error: failure.message)), (
      response,
    ) {
      emit(GroupDeleted(response: response));
      fetchGroups(); // refresh the list after deletion
    });
  }

  /// 🔹 Edit / Update product group
  Future<void> editProductGroup(
    int groupId,
    EditProductGroupRequestModel request,
  ) async {
    emit(GroupEditLoading());

    final response = await _editProductGroupUseCase(groupId, request);

    response.fold((failure) => emit(GroupEditError(error: failure.message)), (
      response,
    ) {
      emit(GroupEdited(response: response));
      fetchGroups();
    });
  }
}
