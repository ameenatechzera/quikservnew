import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/accountGroups/data/models/accountGroupModel.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/repositories/account_group_repository.dart';

class FetchAccountGroupsUseCase
    implements UseCaseWithoutParams<AccountGroupResponse> {
  final AccountGroupRepository _accountGroupsRepository;

  FetchAccountGroupsUseCase(this._accountGroupsRepository);

  @override
  ResultFuture<AccountGroupResponse> call() async {
    return _accountGroupsRepository.fetchAccountGroups();
  }
}