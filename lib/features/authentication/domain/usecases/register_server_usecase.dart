import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/authentication/domain/entities/register_server_response_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';

class RegisterServerUseCase
    implements
        UseCaseWithParams<RegisterResponseResult, RegisterServerRequest> {
  final AuthRepository _authRepository;

  RegisterServerUseCase(this._authRepository);

  @override
  ResultFuture<RegisterResponseResult> call(
    RegisterServerRequest registerResponseResult,
  ) async => _authRepository.registerServer(registerResponseResult);
}
