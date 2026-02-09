part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponseResult result;

  const RegisterSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

final class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ChangePassworsLoading extends RegisterState {}

class ChangePasswordSuccess extends RegisterState {
  const ChangePasswordSuccess();
}

class ChangePasswordFailure extends RegisterState {
  final String message;

  const ChangePasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
