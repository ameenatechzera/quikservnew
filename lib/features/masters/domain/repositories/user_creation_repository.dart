import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/data/models/user_types_model.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';

abstract class UserCreationRepository {
  ResultFuture<UserTypesModel> fetchUserTypes();
  ResultFuture<MasterResponseModel> saveUserTypes(SaveUserParameters request);

}