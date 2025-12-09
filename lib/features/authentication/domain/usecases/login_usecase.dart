import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/authentication/domain/entities/login_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';

class LoginServerUseCase
    implements UseCaseWithParams<LoginResponseResult, LoginRequest> {
  final AuthRepository _authRepository;

  LoginServerUseCase(this._authRepository);

  @override
  ResultFuture<LoginResponseResult> call(LoginRequest loginRequest) async =>
      _authRepository.loginServer(loginRequest);
}
