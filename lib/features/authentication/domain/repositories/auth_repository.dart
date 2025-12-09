import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/authentication/domain/entities/login_entity.dart';
import 'package:quikservnew/features/authentication/domain/entities/register_server_response_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';

abstract class AuthRepository {
  ResultFuture<RegisterResponseResult> registerServer(
    RegisterServerRequest registerServerParams,
  );
  ResultFuture<LoginResponseResult> loginServer(LoginRequest loginRequest);
}
