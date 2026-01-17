import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

abstract class GroupsRepository {
  ResultFuture<FetchGroupResponseModel> fetchGroups();
  ResultFuture<MasterResponseModel> addProductGroup(
    AddProductGroupRequestModel params,
  );
  ResultFuture<MasterResponseModel> deleteProductGroup(int groupId);
  ResultFuture<MasterResponseModel> editProductGroup(
    int groupId,
    EditProductGroupRequestModel params,
  );
}
