import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/authentication/domain/entities/register_server_response_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/domain/usecases/register_server_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterServerUseCase _registerServerUseCase;

  RegisterCubit({required RegisterServerUseCase registerServerUseCase})
    : _registerServerUseCase = registerServerUseCase,
      super(RegisterInitial());

  /// 🔥 Call this method to register server
  Future<void> registerServer(
    RegisterServerRequest registerServerRequest,
  ) async {
    emit(RegisterLoading());

    final response = await _registerServerUseCase(registerServerRequest);

    response.fold(
      (failure) {
        emit(RegisterFailure(failure.message));
      },
      (response) {
        emit(RegisterSuccess(response));
      },
    );
  }
}
