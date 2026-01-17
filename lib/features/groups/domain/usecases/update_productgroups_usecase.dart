import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class EditProductGroupUseCase {
  final GroupsRepository _groupsRepository;

  EditProductGroupUseCase(this._groupsRepository);

  ResultFuture<MasterResponseModel> call(
    int groupId,
    EditProductGroupRequestModel request,
  ) async {
    return _groupsRepository.editProductGroup(groupId, request);
  }
}
