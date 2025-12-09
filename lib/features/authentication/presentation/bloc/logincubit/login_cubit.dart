import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/authentication/domain/entities/login_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginServerUseCase _loginUseCase;

  LoginCubit({required LoginServerUseCase loginServerUseCase})
    : _loginUseCase = loginServerUseCase,
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
}
