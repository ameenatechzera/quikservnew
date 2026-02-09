import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/authentication/domain/parameters/changepassword_parameter.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class ChangePasswordUseCase
    implements UseCaseWithParams<MasterResponseModel, ChangePasswordRequest> {
  final AuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  @override
  ResultFuture<MasterResponseModel> call(ChangePasswordRequest params) async =>
      _authRepository.changePassword(params);
}
