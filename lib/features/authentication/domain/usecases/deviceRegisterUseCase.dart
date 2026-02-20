

import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/authentication/domain/entities/deviceRegisterResult.dart';
import 'package:quikservnew/features/authentication/domain/parameters/deviceRegisterRequest.dart';
import 'package:quikservnew/features/authentication/domain/repositories/auth_repository.dart';

class CheckDeviceRegisterStatusUseCase
    implements UseCaseWithParams<DeviceRegisterResult,DeviceRegisterRequest> {
  final AuthRepository _authRepository;

  CheckDeviceRegisterStatusUseCase(this._authRepository);

  @override
  ResultFuture<DeviceRegisterResult> call(DeviceRegisterRequest) async =>
      _authRepository.deviceRegister(DeviceRegisterRequest);
}