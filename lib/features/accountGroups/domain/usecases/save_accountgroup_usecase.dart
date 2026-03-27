import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class SaveAccountGroupUseCase
    implements
        UseCaseWithParams<MasterResponseModel, SaveAccountGroupRequest> {
  final AccountGroupRepository _accountGroupRepository;

  SaveAccountGroupUseCase(this._accountGroupRepository);

  @override
  ResultFuture<MasterResponseModel> call(
      SaveAccountGroupRequest params,
      ) async {
    return _accountGroupRepository.saveAccountGroup(params);
  }
}