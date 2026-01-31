import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/delete_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/update_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/deleteAccountGroupUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/fetchAccountGroupsUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/saveAccountGroupUseCase.dart';
import 'package:quikservnew/features/accountGroups/domain/usecases/updateAccountGroupUseCase.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

part 'account_group_state.dart';

class AccountGroupCubit extends Cubit<AccountGroupState> {
  final FetchAccountGroupsUseCase _fetchAccountGroupsUseCase;
  final SaveAccountGroupUseCase _saveAccountGroupUseCase;
  final DeleteAccountGroupUseCase _deleteAccountGroupUseCase;
  final UpdateAccountGroupUseCase _updateAccountGroupUseCase;
  AccountGroupCubit({
    required FetchAccountGroupsUseCase fetchAccountGroupsUseCase,
    required SaveAccountGroupUseCase saveAccountGroupUseCase,
    required DeleteAccountGroupUseCase deleteAccountGroupUseCase,
    required UpdateAccountGroupUseCase updateAccountGroupUseCase,
  }) : _fetchAccountGroupsUseCase = fetchAccountGroupsUseCase,
       _saveAccountGroupUseCase = saveAccountGroupUseCase,
       _deleteAccountGroupUseCase = deleteAccountGroupUseCase,
       _updateAccountGroupUseCase = updateAccountGroupUseCase,
       super(AccountGroupInitial());

  Future<void> fetchAccountGroups() async {
    emit(AccountGroupInitial());

    final response = await _fetchAccountGroupsUseCase();

    response.fold(
      (failure) => emit(AccountGroupsError(error: failure.message)),
      (response) => emit(AccountGroupsLoaded(account_groups: response.data)),
    );
  }

  Future<void> saveAccountGroups(SaveAccountGroupRequest request) async {
    emit(SaveAccountGroupInitial());

    final response = await _saveAccountGroupUseCase(request);

    response.fold(
      (failure) => emit(SaveAccountGroupsError(error: failure.message)),
      (response) => emit(SaveAccountGroupCompleted(result: response)),
    );
  }

  Future<void> deleteAccountGroups(DeleteAccountGroupRequest request) async {
    emit(DeleteAccountGroupInitial());

    final response = await _deleteAccountGroupUseCase(request);

    response.fold(
      (failure) => emit(DeleteAccountGroupsError(error: failure.message)),
      (response) => emit(DeleteAccountGroupCompleted(result: response)),
    );
  }

  Future<void> updateAccountGroups(UpdateAccountGroupRequest request) async {
    print('UpdateRequest ${request.toJson()}');
    emit(UpdateAccountGroupInitial());

    final response = await _updateAccountGroupUseCase(request);

    response.fold(
      (failure) => emit(UpdateAccountGroupsError(error: failure.message)),
      (response) => emit(UpdateAccountGroupCompleted(result: response)),
    );
  }
}
