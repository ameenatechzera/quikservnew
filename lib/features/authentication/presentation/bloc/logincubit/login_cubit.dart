import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/authentication/domain/entities/deviceRegisterResult.dart';
import 'package:quikservnew/features/authentication/domain/entities/login_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/deviceRegisterRequest.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/usecases/deviceRegisterUseCase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginServerUseCase _loginUseCase;
  final CheckDeviceRegisterStatusUseCase _checkDeviceRegisterStatusUseCase;

  LoginCubit({required LoginServerUseCase loginServerUseCase , required CheckDeviceRegisterStatusUseCase checkDeviceRegisterStatusUseCase})
    : _loginUseCase = loginServerUseCase, _checkDeviceRegisterStatusUseCase = checkDeviceRegisterStatusUseCase,
      super(LoginInitial());

  Future<void> loginUser(LoginRequest loginRequest) async {
    emit(LoginLoading());
    try {
      final result = await _loginUseCase(loginRequest);

      result.fold(
        (failure) {
          emit(LoginFailure(failure.message));
        },
        (loginResponse) {
          emit(LoginSuccess(loginResponse));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(LoginFailure('An unexpected error occurred'));
    }
  }

  Future<void> checkDeviceRegisterStatus(DeviceRegisterRequest request) async {
    print('DeviceRegisterRequest $request');
    emit(DeviceRegisterLoading());
    try {
      final result = await _checkDeviceRegisterStatusUseCase(request);

      result.fold(
            (failure) {
          emit(DeviceRegisterStatusFailure(failure.message));
        },
            (loginResponse) {
          emit(DeviceRegisterStatusSuccess(loginResponse));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(DeviceRegisterStatusFailure('An unexpected error occurred'));
    }
  }
}
