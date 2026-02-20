import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/authentication/domain/entities/deviceRegisterResult.dart';
import 'package:quikservnew/features/authentication/domain/entities/register_server_response_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/changepassword_parameter.dart';
import 'package:quikservnew/features/authentication/domain/parameters/deviceRegisterRequest.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/domain/usecases/change_password_usecase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/deviceRegisterUseCase.dart';
import 'package:quikservnew/features/authentication/domain/usecases/register_server_usecase.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterServerUseCase _registerServerUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final CheckDeviceRegisterStatusUseCase _checkDeviceRegisterStatusUseCase;
  RegisterCubit({
    required RegisterServerUseCase registerServerUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required CheckDeviceRegisterStatusUseCase checkDeviceRegisterStatusUseCase
  }) : _registerServerUseCase = registerServerUseCase,
       _changePasswordUseCase = changePasswordUseCase,
        _checkDeviceRegisterStatusUseCase = checkDeviceRegisterStatusUseCase,
       super(RegisterInitial());
  //Device Register Status
  Future<void> checkDeviceRegisterStatus(DeviceRegisterRequest request) async {
    print('DeviceRegisterRequest $request');
    emit(DeviceRegisterStatusLoading());
    try {
      final result = await _checkDeviceRegisterStatusUseCase(request);

      result.fold(
            (failure) {
          emit(DeviceRegisterFailure(failure.message));
        },
            (loginResponse) {
          emit(DeviceRegisterSuccess(loginResponse));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(DeviceRegisterFailure('An unexpected error occurred'));
    }
  }
  /// 🔥 Called this method to register server
  Future<void> registerServer(
    RegisterServerRequest registerServerRequest,
  ) async {
    print('request $registerServerRequest');
    emit(RegisterLoading());

    final response = await _registerServerUseCase(registerServerRequest);

    response.fold(
      (failure) {
        emit(RegisterFailure(failure.message));
      },
      (response) async {
        final company = response.companyDetails.first;

        await SharedPreferenceHelper().setDatabaseName(
          company.databaseName ?? '',
        );
        await SharedPreferenceHelper().setExpiryDate(company.expiryDate ?? '');
        await SharedPreferenceHelper().setCompanyName(company.companyName);
        await SharedPreferenceHelper().setCompanyAddress1(company.address1);
        await SharedPreferenceHelper().setCompanyAddress2(company.address2);
        await SharedPreferenceHelper().setCompanyPhoneNo(company.phone);
        print('RegisterSuccess');

        emit(RegisterSuccess(response));
      },
    );
  }

  /// 🔐 Change password (ADDED HERE ONLY)
  Future<void> changePassword(ChangePasswordRequest request) async {
    emit(ChangePassworsLoading());

    final response = await _changePasswordUseCase(request);

    response.fold(
      (failure) {
        emit(ChangePasswordFailure(failure.message));
      },
      (_) {
        emit(const ChangePasswordSuccess());
      },
    );
  }
}
