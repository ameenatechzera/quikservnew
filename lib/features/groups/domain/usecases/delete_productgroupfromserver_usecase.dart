import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class DeleteProductGroupUseCase
    implements UseCaseWithParams<MasterResponseModel, int> {
  final GroupsRepository _groupsRepository;

  DeleteProductGroupUseCase(this._groupsRepository);

  @override
  ResultFuture<MasterResponseModel> call(int groupId) async {
    return _groupsRepository.deleteProductGroup(groupId);
  }
}
