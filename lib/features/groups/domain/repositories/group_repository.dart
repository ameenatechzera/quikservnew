import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';

abstract class GroupsRepository {
  ResultFuture<FetchGroupResponseModel> fetchGroups();
}
