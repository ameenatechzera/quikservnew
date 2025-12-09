import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';

class FetchGroupsUseCase
    implements UseCaseWithoutParams<FetchGroupResponseModel> {
  final GroupsRepository _groupsRepository;

  FetchGroupsUseCase(this._groupsRepository);

  @override
  ResultFuture<FetchGroupResponseModel> call() async {
    return _groupsRepository.fetchGroups();
  }
}
