import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/repositories/group_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class AddProductGroupUseCase
    implements
        UseCaseWithParams<MasterResponseModel, AddProductGroupRequestModel> {
  final GroupsRepository _groupsRepository;

  AddProductGroupUseCase(this._groupsRepository);

  @override
  ResultFuture<MasterResponseModel> call(
    AddProductGroupRequestModel params,
  ) async {
    return _groupsRepository.addProductGroup(params);
  }
}
