import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/update_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class UpdateAccountGroupUseCase
    implements
        UseCaseWithParams<MasterResponseModel, UpdateAccountGroupRequest> {
  final AccountGroupRepository _accountGroupRepository;

  UpdateAccountGroupUseCase(this._accountGroupRepository);

  @override
  ResultFuture<MasterResponseModel> call(
      UpdateAccountGroupRequest params,
      ) async {
    return _accountGroupRepository.updateAccountGroup(params);
  }
}