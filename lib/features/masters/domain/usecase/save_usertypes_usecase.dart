import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/features/masters/domain/repositories/user_creation_repository.dart';

class SaveUserUseCase {
  final UserCreationRepository _userCreationRepository;

  SaveUserUseCase(this._userCreationRepository);

  ResultFuture<MasterResponseModel> call(
      SaveUserParameters request,
      ) async {
    return _userCreationRepository.saveUserTypes( request);
  }
}
