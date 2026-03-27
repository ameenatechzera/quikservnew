import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/delete_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class DeleteAccountGroupUseCase
    implements
        UseCaseWithParams<MasterResponseModel, DeleteAccountGroupRequest> {
  final AccountGroupRepository _accountGroupRepository;

  DeleteAccountGroupUseCase(this._accountGroupRepository);

  @override
  ResultFuture<MasterResponseModel> call(
      DeleteAccountGroupRequest params,
      ) async {
    return _accountGroupRepository.deleteAccountGroup(params);
  }
}